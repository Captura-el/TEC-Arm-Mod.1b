cmake_minimum_required(VERSION 3.27)

# Roots
include("../roots.cmake")

set(CONTEXT ARMCM7.Debug+ARMCM7)
set(TARGET ${CONTEXT})
set(DNAME ARMCM7)
set(DPACK ARM::Cortex_DFP@1.1.0)
set(DPACK_DIR "${CMSIS_PACK_ROOT}/ARM/Cortex_DFP/1.1.0")
set(OUT_DIR "${SOLUTION_ROOT}/out/ARMCM7/ARMCM7/Debug")
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(HEX_FILE "ARMCM7.hex")
set(LD_MAP_FILE "ARMCM7.axf.map")
set(LD_SCRIPT "${SOLUTION_ROOT}/ARMCM7/RTE/Device/ARMCM7/ARMCM7_ac6.sct")
set(LD_SCRIPT_PP ${LD_SCRIPT})

# Processor Options
set(CPU Cortex-M7)
set(FPU DP_FPU)

# Toolchain config map
set(COMPILER AC6)
include("toolchain.cmake")

# Setup project
project(${CONTEXT} LANGUAGES C)

# Enable color diagnostics
set(CMAKE_COLOR_DIAGNOSTICS ON)

# Compilation database
add_custom_target(database
  COMMAND ${CMAKE_COMMAND} -E make_directory "${OUT_DIR}"
  COMMAND ${CMAKE_COMMAND} -E copy_if_different "${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json" "${OUT_DIR}"
)
set(CMAKE_C_STANDARD_INCLUDE_DIRECTORIES ${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES})

# Setup context
add_executable(${CONTEXT})
set_target_properties(${CONTEXT} PROPERTIES PREFIX "" SUFFIX ".axf" OUTPUT_NAME "ARMCM7")
set_target_properties(${CONTEXT} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${OUT_DIR})
add_library(${CONTEXT}_GLOBAL INTERFACE)

# Includes
target_include_directories(${CONTEXT} PUBLIC
  "${SOLUTION_ROOT}/ARMCM7/RTE/_Debug_ARMCM7"
  "${CMSIS_PACK_ROOT}/ARM/CMSIS/6.3.0/CMSIS/Core/Include"
  "${CMSIS_PACK_ROOT}/ARM/Cortex_DFP/1.1.0/Device/ARMCM7/Include"
)

# Defines
target_compile_definitions(${CONTEXT} PUBLIC
  $<$<COMPILE_LANGUAGE:C,CXX>:
    ARMCM7
    _RTE_
  >
)

# Compile options
target_compile_options(${CONTEXT} PUBLIC
  $<$<COMPILE_LANGUAGE:C>:
    "SHELL:${CC_CPU}"
    "SHELL:${CC_FLAGS}"
    "SHELL:-gdwarf-5"
    "SHELL:-std=gnu11"
    "SHELL:-Wno-macro-redefined"
    "SHELL:-Wno-pragma-pack"
    "SHELL:-Wno-parentheses-equality"
    "SHELL:-Wno-license-management"
  >
)

# Compile Options Abstractions
add_library(${CONTEXT}_ABSTRACTIONS INTERFACE)
cbuild_set_options_flags(CC "none" "on" "" "" CC_OPTIONS_FLAGS_${CONTEXT})
target_compile_options(${CONTEXT}_ABSTRACTIONS INTERFACE
  $<$<COMPILE_LANGUAGE:C>:
    "SHELL:${CC_OPTIONS_FLAGS_${CONTEXT}}"
  >
)

# Add groups and components
include("groups.cmake")
include("components.cmake")

target_link_libraries(${CONTEXT} PUBLIC
  Group_Source_Files
  ARM_CMSIS_CORE_6_2_0
  ARM_Device_Startup_C_Startup_2_2_0
)

# Linker options
target_link_options(${CONTEXT} PUBLIC
  "SHELL:${LD_CPU}"
  "SHELL:${_LS}\"${LD_SCRIPT_PP}\""
  "SHELL:${LD_MAP}"
  "SHELL:--entry=Reset_Handler"
  "SHELL:--info=summarysizes"
  "SHELL:--summary_stderr"
  "SHELL:--diag_suppress=L6314W"
)
set(LD_DEPS ${LD_SCRIPT})
set_target_properties(${CONTEXT} PROPERTIES LINK_DEPENDS "${LD_DEPS}")

# Hex Conversion
add_custom_command(TARGET ${CONTEXT} POST_BUILD COMMAND ${CMAKE_OBJCOPY} ${ELF2HEX})
