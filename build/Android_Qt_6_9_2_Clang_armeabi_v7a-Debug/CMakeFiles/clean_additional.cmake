# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/appPlantGPT_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/appPlantGPT_autogen.dir/ParseCache.txt"
  "appPlantGPT_autogen"
  )
endif()
