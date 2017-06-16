package spatial.nodes

import argon.core._
import spatial.compiler._

case class SwitchCase[T:Type](body: Block[T]) extends Op[T] {
  def mirror(f:Tx) = Switches.op_case(f(body))

  override def freqs = cold(body)
  val mT = typ[T]
}

case class Switch[T:Type](body: Block[T], selects: Seq[Exp[Bit]], cases: Seq[Exp[T]]) extends Op[T] {
  def mirror(f:Tx) = {
    val body2 = stageHotBlock{
      val body2 = f(body)
      body2()
    }
    Switches.op_switch(body2, f(selects), f(cases))
  }
  override def inputs = dyns(selects)
  override def binds = dyns(cases)
  override def freqs = hot(body)   // Move everything except cases out of body
  val mT = typ[T]
}