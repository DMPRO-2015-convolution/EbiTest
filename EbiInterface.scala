package ebi

import Chisel._

class EbiInterface extends Chisel.Module {

	val width = 16;

	val io = new Bundle {
		val ebiData = UInt(INPUT, width)
		val valid = Bool(OUTPUT)
		val invalid = Bool(OUTPUT)
	}

	val nextValue = Reg(UInt(0, width))
	val valid = Reg(Bool())

	val queue = Module(
			new AsyncFifo(
				UInt(width = 16),
				4,
				Clock(),
				Driver.implicitClock
			)
		)

	queue.io.enq.bits := io.ebiData
	queue.io.enq.valid := Bool(true)
	queue.io.deq.ready := Bool(true)

	io.invalid := !valid
	io.valid := valid

	when (queue.io.deq.valid) {
		valid := queue.io.deq.bits === nextValue
		nextValue := nextValue + UInt(1)
	}
}
