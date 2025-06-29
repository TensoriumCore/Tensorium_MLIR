; ModuleID = 'tensorium_export/proto_func_tensorium_gpu.cpp'
source_filename = "tensorium_export/proto_func_tensorium_gpu.cpp"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx15.0.0"

@.str = private unnamed_addr constant [14 x i8] c"tensorium_gpu\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [46 x i8] c"tensorium_export/proto_func_tensorium_gpu.cpp\00", section "llvm.metadata"
@llvm.global.annotations = appending global [1 x { ptr, ptr, ptr, i32, ptr }] [{ ptr, ptr, ptr, i32, ptr } { ptr @_Z10proto_funcv, ptr @.str, ptr @.str.1, i32 2, ptr null }], section "llvm.metadata"

; Function Attrs: mustprogress noinline nounwind optnone ssp uwtable
define void @_Z10proto_funcv() #0 {
  ret void
}

attributes #0 = { mustprogress noinline nounwind optnone ssp uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"uwtable", i32 2}
!3 = !{i32 7, !"frame-pointer", i32 2}
!4 = !{!"clang version 21.0.0git (https://github.com/llvm/llvm-project.git 3c02150f02022292645f6238524f0401a6f5014f)"}
