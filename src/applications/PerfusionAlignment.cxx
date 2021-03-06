#include "PerfusionAlignment.h"
#include "cbicaUtilities.h"
#include "cbicaCmdParser.h"

int main(int argc, char **argv)
{
  cbica::CmdParser parser = cbica::CmdParser(argc, argv, "PerfusionAlignment");
  parser.addRequiredParameter("i", "input", cbica::Parameter::STRING, "", "The input DSC-MRI image.");
  parser.addRequiredParameter("b", "time-points before drop", cbica::Parameter::STRING, "", "The number of time-points before the drop.");
  parser.addRequiredParameter("a", "time-points after drop", cbica::Parameter::STRING, "", "The number of time-points after the drop.");
  parser.addRequiredParameter("t", "time-domain resolution", cbica::Parameter::FLOAT, "", "The time-interval (spacing) between two consecutive volumes in time-domain (in seconds).");

  parser.addRequiredParameter("o", "output", cbica::Parameter::STRING, "", "The output directory.");
  parser.addOptionalParameter("s", "drop-scaling", cbica::Parameter::INTEGER, "", "Whether to scale the value of the drop of the curve? 1=yes, 0=no, default=0.");
  parser.addOptionalParameter("L", "Logger", cbica::Parameter::STRING, "log file which user has write access to", "Full path to log file to store console outputs", "By default, only console output is generated");
  //parser.exampleUsage("PerfusionAlignment -i AAAC_PreOp_perf_pp.nii.gz -d AAAC_PreOp_perf_pp.dcm -o <output dir>");
  parser.addExampleUsage("-i AAAC_PreOp_perf_pp.nii.gz -c AAAC_PreOp_t1ce_pp.nii.gz -b 15 -a 17 -t 2 -o <output dir>", "Aligns the perfusion signal of the input image based on the time points");
  parser.addApplicationDescription("Perfusion Alignment of the input based based on specified time points");

  // parameters to get from the command line
  cbica::Logging logger;
  std::string loggerFile;
  bool loggerRequested = false;
  int tempPosition;
  int pointsbeforedrop, pointsafterdrop;
  int dropscaling = 0;
  double timeresolution;
  std::string inputFileName, inputDicomName, outputDirectoryName,inputt1ceName;

  if (parser.compareParameter("L", tempPosition))
  {
    loggerFile = argv[tempPosition + 1];
    loggerRequested = true;
    logger.UseNewFile(loggerFile);
  }
  if (parser.compareParameter("i", tempPosition))
  {
    inputFileName = argv[tempPosition + 1];
  }
  if (parser.compareParameter("o", tempPosition))
  {
    outputDirectoryName = argv[tempPosition + 1];
  }

  if (parser.compareParameter("b", tempPosition))
    pointsbeforedrop = atoi(argv[tempPosition + 1]);

  if (parser.compareParameter("t", tempPosition))
    timeresolution = atof(argv[tempPosition + 1]);

  if (parser.compareParameter("a", tempPosition))
    pointsafterdrop = atoi(argv[tempPosition + 1]);

  if (parser.compareParameter("s", tempPosition))
    dropscaling = atoi(argv[tempPosition + 1]);

  // std::cout << "Input File:" << inputFileName << std::endl;
  // std::cout << "Output Directory:" << outputDirectoryName << std::endl;
  // cbica::Logging(loggerFile, "Input directory name: " + inputFileName + "\n");
	// cbica::Logging(loggerFile, "Output directory name: " + outputDirectoryName + "\n");

  if (!cbica::isFile(inputFileName))
  {
    std::cout << "The input file does not exist:" << inputFileName << std::endl;
    return EXIT_FAILURE;
  }
  cbica::createDirectory(outputDirectoryName);
  
  PerfusionAlignment objPerfusion;
  std::vector<double> OriginalCurve, InterpolatedCurve, RevisedCurve, TruncatedCurve;
  std::vector<typename ImageTypeFloat3D::Pointer> PerfusionAlignment = objPerfusion.Run<ImageTypeFloat3D, ImageTypeFloat4D>(inputFileName, pointsbeforedrop,pointsafterdrop,OriginalCurve,InterpolatedCurve, RevisedCurve,TruncatedCurve, timeresolution,dropscaling);
  //std::vector<typename ImageTypeFloat3D::Pointer> PerfusionAlignment = objPerfusion.Run<ImageTypeFloat3D, ImageTypeFloat4D>("//cbica-cifs/hasun/comp_space/180815_Henry_Ford/Protocols/5_SSFinal/2/2/2_perf_LPS_r_SSFinal.nii.gz", "W:/perf/MSh_PERF_AX-1001_echo1_I000001.dcm", "//cbica-cifs/hasun/comp_space/180815_Henry_Ford/Protocols/5_SSFinal/2/2/2_t1ce_LPS_r_SSFinal.nii.gz", 17, 40);
  //for (int index = 0; index < PerfusionAlignment.size(); index++)
  //{
  //  std::cout << "Writing time-point: " << index+1 << "/" << PerfusionAlignment.size() << std::endl;
  //  cbica::WriteImage<ImageTypeFloat3D>(PerfusionAlignment[index], outputDirectoryName + std::to_string(index+1+pointsbeforedrop) + ".nii.gz");
  //}

  if (!PerfusionAlignment.empty())
  {
    auto joinedImage = cbica::GetJoinedImage< ImageTypeFloat3D, ImageTypeFloat4D >(PerfusionAlignment);
    cbica::WriteImage< ImageTypeFloat4D >(joinedImage, outputDirectoryName + "/perfusionAlignedImage.nii.gz");

    WriteCSVFiles(OriginalCurve, outputDirectoryName + "/original_curve.csv");
    WriteCSVFiles(InterpolatedCurve, outputDirectoryName + "/interpolated_curve.csv");
    WriteCSVFiles(RevisedCurve, outputDirectoryName + "/revised_curve.csv");
    WriteCSVFiles(TruncatedCurve, outputDirectoryName + "/truncated_curve.csv");

    std::cout << "Finished successfully.\n";
    std::cout << "\nPress any key to continue............\n";
  }
  else
  {
    std::cerr << "Something went wrong and CaPTk could not align the perfusion signal correctly. Please see prior messages for details.\n";
    return EXIT_FAILURE;
  }

  return EXIT_SUCCESS;
}
