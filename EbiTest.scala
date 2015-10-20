package ebi

import Chisel._

/**
 * Runs chisel
 */
object EbiTest {

	def main(args: Array[String]) {
		chiselMain(args, () => Module(new EbiInterface()))
	}

}
