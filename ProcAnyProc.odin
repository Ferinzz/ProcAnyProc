package main

import "core:fmt"
import "core:math/linalg"
import "core:slice"
import sics "base:intrinsics"
import "base:runtime"
import "core:reflect"

main :: proc () {
  second: int = 3
  num1:int=3
  num2:f64=6
  num3:u8=32
  num4:i32= -86

  //Get the procAny procedure and store in somfunc.
  somefunc:= genvirtue(breaker)
  
  parameters:[10]rawptr = { nil,nil,nil,nil,nil,nil,nil,nil,nil,nil }
  parameters[0]=&num1
  parameters[1]=&num2
  parameters[2]=&num3
  parameters[3]=&num4
  parameters[4]=&num3
  parameters[5]=&num3
  parameters[6]=&num3
  parameters[7]=&num3
  parameters[8]=&num3

  //Use the stored procAny procedure to call the proc sent in the last parameter.
  somefunc(parameters[:], rawptr(breaker))

  fmt.println("procAny/somefunc", somefunc)
  somefunc(parameters[:], rawptr(someProc5))
  somefunc(parameters[:], rawptr(someProc4))
  somefunc(parameters[:], rawptr(someProc3))
  
  fmt.println("procMany", procMany)
  procMany(parameters[:], rawptr(someProc3))

  fmt.println("procSome")
  procSome(parameters[:], rawptr(someProc3))

  fmt.println("procSafer")
  procSafer(parameters[:], rawptr(someProc5))
  procSafer(parameters[:], rawptr(someProc4))
  procSafer(parameters[:], rawptr(someProc3))
  
  fmt.println("procSafest")
  procSafest(parameters[:], someProc5)
  procSafest(parameters[:], someProc4)
  procSafest(parameters[:], someProc3)
}

//Need something which is at least as large as the largest method.
//This will become the core method who's format will be called when the generated procAny is called.
breaker :: proc(first: rawptr, first2: rawptr, first3: rawptr, first4: rawptr) {
  fmt.println("Yooo! I got called.")
  fmt.println(first)
}

//Test procs to call.
someProc5 :: proc(first: ^int, second:^f64) {
  fmt.println("Proc5")
  fmt.println(first^, second^)
}
someProc4 :: proc(first: ^int, second:^f64, third:^u8, fourth:^i32) {
  fmt.println("Proc4")
  fmt.println(first^, second^, third^, fourth^)
}
someProc3 :: proc(first: ^int, second:^f64) {
  fmt.println("Proc3")
  fmt.println(first^, second^)
}

//Need something to generate the procedures.
//If they aren't generated at least once it won't be able to cast to the correct proc.
genvirtue :: proc(procPointer: $T) -> proc (p_args: []rawptr, r_ret: rawptr){

 procAny :: proc (p_args: []rawptr, r_ret: rawptr){
    
    classStructPtr::sics.type_proc_parameter_type(T, 0)
    argcount :: sics.type_proc_parameter_count(T)
    //p_args:[]rawptr = (p_args[:argcount])

    //not sure what kind of magic allows for this to cast to the correct one from just a raw pointer?
    procPointer:= cast(T)r_ret
    procPointer((p_args[0]), p_args[1], (p_args[2]), (p_args[3]))
  }
  return procAny
}


//This also works.
procMany :: proc (p_args: []rawptr, r_ret: rawptr) {
    
  procPointer:= cast(proc(first: rawptr, first2: rawptr, first3: rawptr, first4: rawptr))r_ret
  procPointer((p_args[0]), p_args[1], (p_args[2]), (p_args[3]))
}

//This also works.
procSome :: proc (p_args: []rawptr, r_ret: $T) {
    
  procPointer:= cast(proc(first: rawptr, first2: rawptr, first3: rawptr, first4: rawptr))r_ret
  procPointer((p_args[0]), p_args[1], (p_args[2]), (p_args[3]))
}

procSafer :: proc(p_args: []rawptr, r_ret: rawptr) {

  if len(p_args) == 0 {

    procPointer:= cast(proc())r_ret
    procPointer()
  }
  if len(p_args) == 1 {

    procPointer:= cast(proc(first: rawptr))r_ret
    procPointer(p_args[0])
  }
  if len(p_args) == 2 {

    procPointer:= cast(proc(first: rawptr, first2: rawptr))r_ret
    procPointer(p_args[0], p_args[1])
  }
  if len(p_args) == 3 {

    procPointer:= cast(proc(first: rawptr, first2: rawptr, first3: rawptr))r_ret
    procPointer(p_args[0], p_args[1], (p_args[2]))
  }
  if len(p_args) == 4 {

    procPointer:= cast(proc(first: rawptr, first2: rawptr, first3: rawptr, first4: rawptr))r_ret
    procPointer(p_args[0], p_args[1], (p_args[2]), (p_args[3]))
  }

  procPointer:= cast(proc(first: rawptr, first2: rawptr, first3: rawptr, first4: rawptr))r_ret
  procPointer((p_args[0]), p_args[1], (p_args[2]), (p_args[3]))

}


procSafest :: proc(p_args: []rawptr, r_ret: $T) where sics.type_is_proc(T) {

  when sics.type_proc_parameter_count(T) == 0 {

    procPointer:= cast(proc())r_ret
    procPointer()
  }
  when sics.type_proc_parameter_count(T) == 1 {
    panic(!sics.type_is_pointer(sics.type_proc_parameter_type(T, 0)))
    procPointer:= cast(proc(first: rawptr))r_ret
    procPointer(p_args[0])
  }
  when sics.type_proc_parameter_count(T) == 2 {

    procPointer:= cast(proc(first: rawptr, first2: rawptr))r_ret
    procPointer(p_args[0], p_args[1])
  }
  when sics.type_proc_parameter_count(T) == 3 {

    procPointer:= cast(proc(first: rawptr, first2: rawptr, first3: rawptr))r_ret
    procPointer(p_args[0], p_args[1], (p_args[2]))
  }
  when sics.type_proc_parameter_count(T) == 4 {

    procPointer:= cast(proc(first: rawptr, first2: rawptr, first3: rawptr, first4: rawptr))r_ret
    procPointer(p_args[0], p_args[1], (p_args[2]), (p_args[3]))
  }
}
