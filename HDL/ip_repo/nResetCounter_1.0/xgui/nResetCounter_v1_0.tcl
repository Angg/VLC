# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"

  set LIMIT_COUNT [ipgui::add_param $IPINST -name "LIMIT_COUNT"]
  set_property tooltip {Limit value for up counter} ${LIMIT_COUNT}

}

proc update_PARAM_VALUE.LIMIT_COUNT { PARAM_VALUE.LIMIT_COUNT } {
	# Procedure called to update LIMIT_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LIMIT_COUNT { PARAM_VALUE.LIMIT_COUNT } {
	# Procedure called to validate LIMIT_COUNT
	return true
}


proc update_MODELPARAM_VALUE.LIMIT_COUNT { MODELPARAM_VALUE.LIMIT_COUNT PARAM_VALUE.LIMIT_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LIMIT_COUNT}] ${MODELPARAM_VALUE.LIMIT_COUNT}
}

