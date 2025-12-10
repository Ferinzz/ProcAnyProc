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

  somefunc:= genvirtue(breaker)
  
  //somefunc= genvirtue(someProc5)
  //somefunc= genvirtue(someProc4)
  //somefunc= genvirtue(someProc3)
  //somefunc= genvirtue(breaker)
  
  
  num3:u8=32
  num4: i32 = -86
  parameters:[10]rawptr = { nil,nil,nil,nil,nil,nil,nil,nil,nil,nil }
  parameters[0] =&num1
  parameters[1]=&num2
  parameters[2]=&num3
  parameters[3]=&num4
  parameters[4]=&num3
  parameters[5]=&num3
  parameters[6]=&num3
  parameters[7]=&num3
  parameters[8]=&num3

  somefunc(parameters[:], rawptr(breaker))

  somefunc(parameters[:], rawptr(someProc5))
  somefunc(parameters[:], rawptr(someProc4))
  somefunc(parameters[:], rawptr(someProc3))
}

//Need something which is at least as large as the largest method.
//This will become the core method which will be called by whatever needs the generic call.
breaker :: proc(first: ^int, first2: ^int, first3: ^int, first4: ^int) {
  fmt.println("Yooo! I got called.")
  fmt.println(first)
}
someProc5 :: proc(first: ^int, second:^f64) {
  fmt.println("Second call? Yes!")
  fmt.println(first^, second^)
}
someProc4 :: proc(first: ^int, second:^f64, third:^u8, fourth:^i32) {
  fmt.println("Second call? Yes!")
  fmt.println(first^, second^, third^, fourth^)
}
someProc3 :: proc(first: ^int, second:^f64) {
  fmt.println("Second call? Yes!")
  fmt.println(first^, second^)
}

anyproc:: struct {
  virtuousCall: proc (many: any, p_instance: int, p_args: []rawptr, r_ret: rawptr),
  origsin: rawptr,
}

//Need something to generate the procedures.
//If they aren't generated at least once it won't be able to cast to the correct proc.
genvirtue :: proc(procPointer: $T) -> proc (p_args: []rawptr, r_ret: rawptr){

return proc (p_args: []rawptr, r_ret: rawptr){
    
    classStructPtr::sics.type_proc_parameter_type(T, 0)
    argcount :: sics.type_proc_parameter_count(T)
    //p_args:[]rawptr = (p_args[:argcount])

    //not sure what kind of magic allows for this to cast to the correct one from just a raw pointer?
    procPointer:= cast(T)r_ret
    when argcount == 1 {
        when sics.type_proc_return_count(T) > 0 {
            (cast(sics.type_proc_return_type(T, 0))r_ret)^ = procPointer(cast(classStructPtr)p_instance)
        } else {
        procPointer((cast(^classStructPtr)p_args[0])^)
      }
    }
    when argcount > 1 do argT0::sics.type_proc_parameter_type(T, 1)
    when argcount > 2 do argT1 :: sics.type_proc_parameter_type(T, 2)
    when argcount > 3 do argT2 :: sics.type_proc_parameter_type(T, 3)
    when argcount > 4 do argT3 :: sics.type_proc_parameter_type(T, 4)
    when argcount > 5 do argT4 :: sics.type_proc_parameter_type(T, 5)
    when argcount > 6 do argT5 :: sics.type_proc_parameter_type(T, 6)
    when argcount > 7 do argT6 :: sics.type_proc_parameter_type(T, 7)
    when argcount > 8 do argT7 :: sics.type_proc_parameter_type(T, 8)
    when argcount > 9 do argT8 :: sics.type_proc_parameter_type(T, 9)
    when argcount > 10 do argT9 :: sics.type_proc_parameter_type(T, 10)
    
    when argcount == 4 {
        when sics.type_proc_return_count(T) > 0 {
            (cast(sics.type_proc_return_type(T, 0))r_ret)^ = procPointer(cast(classStructPtr)p_instance, (cast(^argT0)p_args[0])^, (cast(^argT1)p_args[1])^, (cast(^argT2)p_args[2])^)
        } else {
            fmt.println((cast(^classStructPtr)p_args[0])^)
            fmt.println((cast(^f64)p_args[1])^)
            fmt.println((cast(^argT1)p_args[2])^)
            fmt.println((cast(^argT2)p_args[3])^)
            procPointer((cast(classStructPtr)p_args[0]), cast(argT0)p_args[1], (cast(argT1)p_args[2]), (cast(argT2)p_args[3]))
        }
    }}}

