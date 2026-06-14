if {[file exists work]} {
    vdel -lib work -all
}

vlib work

# =====================================
# FIFO
# =====================================

vcom my_fifo/my_counter.vhd
vcom my_fifo/register_file.vhd
vcom my_fifo/fifo_controller.vhd
vcom my_fifo/my_fifo.vhd

# =====================================
# Routing Unit
# =====================================

vcom RoutingUnit/RoutingUnit.vhd

# =====================================
# Arbiter
# =====================================

vcom arbiter_project/single_arbiter.vhd
vcom arbiter_project/arbiter_project.vhd

# =====================================
# Crossbar
# =====================================

vcom CrossbarSwitch/CrossbarSwitch.vhd

# =====================================
# Single Router
# =====================================

vcom router/Router.vhd

# =====================================
# Two Routers (NEW TOP LEVEL)
# =====================================

vcom two_routers/two_routers.vhd

# =====================================
# Testbench
# =====================================

vcom two_routers/TB_two_routers.vhd

# =====================================
# Simulation
# =====================================

vsim work.tb_two_routers

add wave -r sim:/tb_two_routers/*

run 1000 ns