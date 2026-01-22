# Begin_DVE_Session_Save_Info
# DVE full session
# Saved on Thu Jan 22 22:55:04 2026
# Designs open: 1
#   Sim: /home/host/Desktop/RAM-To-GPIO/ram-to-gpio/AHB-GPIO/uvm/sim/out/obj/rkv_gpio_tb.simv
# Toplevel windows open: 1
# 	TopLevel.2
#   Wave.1: 50 signals
#   Group count = 6
#   Group Group3 signal count = 4
#   Group AHB-IF signal count = 21
#   Group GPIO-IF signal count = 9
# End_DVE_Session_Save_Info

# DVE version: O-2018.09-SP2_Full64
# DVE build date: Feb 28 2019 23:39:41


#<Session mode="Full" path="/home/host/Desktop/RAM-To-GPIO/ram-to-gpio/AHB-GPIO/uvm/sim/DVEfiles/session.tcl" type="Debug">

gui_set_loading_session_type Post
gui_continuetime_set

# Close design
if { [gui_sim_state -check active] } {
    gui_sim_terminate
}
gui_close_db -all
gui_expr_clear_all

# Close all windows
gui_close_window -type Console
gui_close_window -type Wave
gui_close_window -type Source
gui_close_window -type Schematic
gui_close_window -type Data
gui_close_window -type DriverLoad
gui_close_window -type List
gui_close_window -type Memory
gui_close_window -type HSPane
gui_close_window -type DLPane
gui_close_window -type Assertion
gui_close_window -type CovHier
gui_close_window -type CoverageTable
gui_close_window -type CoverageMap
gui_close_window -type CovDetail
gui_close_window -type Local
gui_close_window -type Stack
gui_close_window -type Watch
gui_close_window -type Group
gui_close_window -type Transaction



# Application preferences
gui_set_pref_value -key app_default_font -value {Fixed [Misc],14,-1,5,75,0,0,0,0,0}
gui_src_preferences -tabstop 8 -maxbits 24 -windownumber 1
#<WindowLayout>

# DVE top-level session


# Create and position top-level window: TopLevel.2

if {![gui_exist_window -window TopLevel.2]} {
    set TopLevel.2 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.2 TopLevel.2
}
gui_show_window -window ${TopLevel.2} -show_state maximized -rect {{1 38} {2486 1333}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_hide_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_hide_toolbar -toolbar {CopyPaste}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_hide_toolbar -toolbar {TraceInstance}
gui_hide_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}
gui_set_toolbar_attributes -toolbar {Simulator} -dock_state top
gui_set_toolbar_attributes -toolbar {Simulator} -offset 0
gui_show_toolbar -toolbar {Simulator}
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -dock_state top
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -offset 0
gui_show_toolbar -toolbar {Interactive Rewind}
gui_set_toolbar_attributes -toolbar {Testbench} -dock_state top
gui_set_toolbar_attributes -toolbar {Testbench} -offset 0
gui_show_toolbar -toolbar {Testbench}

# End ToolBar settings

# Docked window settings
gui_sync_global -id ${TopLevel.2} -option true

# MDI window settings
set Wave.1 [gui_create_window -type {Wave}  -parent ${TopLevel.2}]
gui_show_window -window ${Wave.1} -show_state maximized
gui_update_layout -id ${Wave.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 721} {child_wave_right 1759} {child_wave_colname 358} {child_wave_colvalue 358} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings

gui_set_env TOPLEVELS::TARGET_FRAME(Source) none
gui_set_env TOPLEVELS::TARGET_FRAME(Schematic) none
gui_set_env TOPLEVELS::TARGET_FRAME(PathSchematic) none
gui_set_env TOPLEVELS::TARGET_FRAME(Wave) none
gui_set_env TOPLEVELS::TARGET_FRAME(List) none
gui_set_env TOPLEVELS::TARGET_FRAME(Memory) none
gui_set_env TOPLEVELS::TARGET_FRAME(DriverLoad) none
gui_update_statusbar_target_frame ${TopLevel.2}

#</WindowLayout>

#<Database>

# DVE Open design session: 

if { [llength [lindex [gui_get_db -design Sim] 0]] == 0 } {
gui_set_env SIMSETUP::SIMARGS {{-a run.log +ntb_random_seed=1 +UVM_TESTNAME=rkv_gpio_interrupt_test +UVM_VERBOSITY=UVM_HIGH -cm_dir out/cov.vdb -cm_name rkv_gpio_interrupt_test_1 -do rkv_gpio_sim_run.do}}
gui_set_env SIMSETUP::SIMEXE {out/obj/rkv_gpio_tb.simv}
gui_set_env SIMSETUP::ALLOW_POLL {0}
if { ![gui_is_db_opened -db {/home/host/Desktop/RAM-To-GPIO/ram-to-gpio/AHB-GPIO/uvm/sim/out/obj/rkv_gpio_tb.simv}] } {
gui_sim_run Ucli -exe rkv_gpio_tb.simv -args { -a run.log +ntb_random_seed=1 +UVM_TESTNAME=rkv_gpio_interrupt_test +UVM_VERBOSITY=UVM_HIGH -cm_dir out/cov.vdb -cm_name rkv_gpio_interrupt_test_1 -do rkv_gpio_sim_run.do -ucligui} -dir /home/host/Desktop/RAM-To-GPIO/ram-to-gpio/AHB-GPIO/uvm/sim/out/obj -nosource
}
}
if { ![gui_sim_state -check active] } {error "Simulator did not start correctly" error}
gui_set_precision 1ps
gui_set_time_units 1ps
#</Database>

# DVE Global setting session: 


# Global: Breakpoints

# Global: Bus

# Global: Expressions

# Global: Signal Time Shift

# Global: Signal Compare

# Global: Signal Groups
gui_load_child_values {rkv_gpio_tb.ahb_if}
gui_load_child_values {rkv_gpio_tb.dut}
gui_load_child_values {rkv_gpio_tb.gpio_if}


set _session_group_1 Group3
gui_sg_create "$_session_group_1"
set Group3 "$_session_group_1"

gui_sg_addsignal -group "$_session_group_1" { rkv_gpio_tb.dut.ECOREVNUM }

set _session_group_2 $_session_group_1|
append _session_group_2 AHB
gui_sg_create "$_session_group_2"
set Group3|AHB "$_session_group_2"

gui_sg_addsignal -group "$_session_group_2" { rkv_gpio_tb.dut.HCLK rkv_gpio_tb.dut.HRESETn rkv_gpio_tb.dut.FCLK rkv_gpio_tb.dut.HSEL rkv_gpio_tb.dut.HREADY rkv_gpio_tb.dut.HTRANS rkv_gpio_tb.dut.HSIZE rkv_gpio_tb.dut.HWRITE rkv_gpio_tb.dut.HADDR rkv_gpio_tb.dut.HWDATA rkv_gpio_tb.dut.HREADYOUT rkv_gpio_tb.dut.HRESP rkv_gpio_tb.dut.HRDATA }

gui_sg_move "$_session_group_2" -after "$_session_group_1" -pos 2 

set _session_group_3 $_session_group_1|
append _session_group_3 INTQ
gui_sg_create "$_session_group_3"
set Group3|INTQ "$_session_group_3"

gui_sg_addsignal -group "$_session_group_3" { rkv_gpio_tb.dut.GPIOINT rkv_gpio_tb.dut.COMBINT }

gui_sg_move "$_session_group_3" -after "$_session_group_1" -pos 1 

set _session_group_4 $_session_group_1|
append _session_group_4 PORT
gui_sg_create "$_session_group_4"
set Group3|PORT "$_session_group_4"

gui_sg_addsignal -group "$_session_group_4" { rkv_gpio_tb.dut.PORTIN rkv_gpio_tb.dut.PORTOUT rkv_gpio_tb.dut.PORTEN rkv_gpio_tb.dut.PORTFUNC }

set _session_group_5 AHB-IF
gui_sg_create "$_session_group_5"
set AHB-IF "$_session_group_5"

gui_sg_addsignal -group "$_session_group_5" { rkv_gpio_tb.ahb_if.hclk rkv_gpio_tb.ahb_if.hresetn rkv_gpio_tb.ahb_if.hgrant rkv_gpio_tb.ahb_if.hrdata rkv_gpio_tb.ahb_if.hready rkv_gpio_tb.ahb_if.hresp rkv_gpio_tb.ahb_if.haddr rkv_gpio_tb.ahb_if.hsize rkv_gpio_tb.ahb_if.htrans rkv_gpio_tb.ahb_if.hwdata rkv_gpio_tb.ahb_if.hwrite rkv_gpio_tb.ahb_if.hburst rkv_gpio_tb.ahb_if.hbusreq rkv_gpio_tb.ahb_if.hlock rkv_gpio_tb.ahb_if.hprot rkv_gpio_tb.ahb_if.debug_hresp rkv_gpio_tb.ahb_if.debug_htrans rkv_gpio_tb.ahb_if.debug_hsize rkv_gpio_tb.ahb_if.debug_hburst rkv_gpio_tb.ahb_if.debug_xact rkv_gpio_tb.ahb_if.debug_status }

set _session_group_6 GPIO-IF
gui_sg_create "$_session_group_6"
set GPIO-IF "$_session_group_6"

gui_sg_addsignal -group "$_session_group_6" { rkv_gpio_tb.gpio_if.clk rkv_gpio_tb.gpio_if.fclk rkv_gpio_tb.gpio_if.rstn rkv_gpio_tb.gpio_if.portin rkv_gpio_tb.gpio_if.portout rkv_gpio_tb.gpio_if.porten rkv_gpio_tb.gpio_if.portfunc rkv_gpio_tb.gpio_if.gpioint rkv_gpio_tb.gpio_if.combint }

# Global: Highlighting

# Global: Stack
gui_change_stack_mode -mode list

# Post database loading setting...

# Restore C1 time
gui_set_time -C1_only 3676000



# Save global setting...

# Wave/List view global setting
gui_cov_show_value -switch false

# Close all empty TopLevel windows
foreach __top [gui_ekki_get_window_ids -type TopLevel] {
    if { [llength [gui_ekki_get_window_ids -parent $__top]] == 0} {
        gui_close_window -window $__top
    }
}
gui_set_loading_session_type noSession
# DVE View/pane content session: 


# View 'Wave.1'
gui_wv_sync -id ${Wave.1} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.1}  C1
gui_wv_zoom_timerange -id ${Wave.1} 3675542 3676457
gui_list_add_group -id ${Wave.1} -after {New Group} {Group3}
gui_list_add_group -id ${Wave.1}  -after Group3 {Group3|PORT}
gui_list_add_group -id ${Wave.1} -after Group3|PORT {Group3|INTQ}
gui_list_add_group -id ${Wave.1} -after Group3|INTQ {Group3|AHB}
gui_list_add_group -id ${Wave.1} -after {New Group} {AHB-IF}
gui_list_add_group -id ${Wave.1} -after {New Group} {GPIO-IF}
gui_list_select -id ${Wave.1} {rkv_gpio_tb.dut.ECOREVNUM }
gui_seek_criteria -id ${Wave.1} {Any Edge}



gui_set_env TOGGLE::DEFAULT_WAVE_WINDOW ${Wave.1}
gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.1} -text {*}
gui_list_set_insertion_bar  -id ${Wave.1} -group GPIO-IF  -position in

gui_marker_move -id ${Wave.1} {C1} 3676000
gui_view_scroll -id ${Wave.1} -vertical -set 0
gui_show_grid -id ${Wave.1} -enable false
# Restore toplevel window zorder
# The toplevel window could be closed if it has no view/pane
if {[gui_exist_window -window ${TopLevel.2}]} {
	gui_set_active_window -window ${TopLevel.2}
	gui_set_active_window -window ${Wave.1}
}
#</Session>

