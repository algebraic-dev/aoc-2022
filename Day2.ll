@variable = global i32 233

declare i8* @read_file(i8*)
declare void @print_int(i64)

@.name = constant [6 x i8] c"input\00"

%Tuple = type { i8, i8 }

define i8 @advance(i8** %fn_ptr) {
    entry:
        %0 = load i8*, i8** %fn_ptr
        %1 = load i8, i8* %0
        %2 = getelementptr i8, i8* %0, i64 1
        store i8* %2, i8** %fn_ptr
        ret i8 %1
}

define %Tuple @read_instruction(i8** %fn_ptr) {
    entry:
        %0 = call i8 @advance(i8** %fn_ptr)
        %1 = call i8 @advance(i8** %fn_ptr)
        %2 = call i8 @advance(i8** %fn_ptr)

        %3 = sub i8 %0, 65
        %4 = sub i8 %2, 88

        %pair = alloca %Tuple
        
        %pair_fst = getelementptr %Tuple, %Tuple* %pair, i32 0, i32 0
        store i8 %3, i8* %pair_fst

        %pair_snd  = getelementptr %Tuple, %Tuple* %pair, i32 0, i32 1
        store i8 %4, i8* %pair_snd

        %pair_val = load %Tuple, %Tuple* %pair
        
        ret %Tuple %pair_val
}

define i64 @calc_other(%Tuple* %tuple) {
    entry: 
        %a3 = getelementptr %Tuple, %Tuple* %tuple, i32 0, i32 0
        %fst = load i8, i8* %a3

        %b3 = getelementptr %Tuple, %Tuple* %tuple, i32 0, i32 1
        %snd = load i8, i8* %b3

        %res_0 = add i8 %snd, 2
        %res_1 = srem i8 %res_0, 3
        %res_2 = add i8 %res_1, %fst
        %res_3 = srem i8 %res_2, 3   
        %res_4 = zext i8 %res_3 to i64
    
        ret i64 %res_4
}

define i64 @points(%Tuple* %tuple) {
    entry:
        %b3 = getelementptr %Tuple, %Tuple* %tuple, i32 0, i32 1
        %snd = load i8, i8* %b3

        %cond = icmp eq i8 %snd, 0

        br i1 %cond, label %lost, label %check_won
    check_won:
        %cond_2 = icmp eq i8 %snd, 1
        br i1 %cond_2, label %draw, label %won
    lost:
        ret i64 0
    won:
        ret i64 6
    draw:
        ret i64 3
}

define i64 @main() {
    entry:
        %0 = bitcast [6 x i8]* @.name to i8*
        %1 = call i8* @read_file(i8* %0)

        %fn_ptr = alloca i8*, align 8
        store i8* %1, i8** %fn_ptr

        br label %loop
    loop:
        %points = phi i64 [0, %entry], [%points_4, %loop]

        %inst = alloca %Tuple, align 8

        %2 = call %Tuple @read_instruction(i8** %fn_ptr)
        store %Tuple %2, %Tuple* %inst
        
        %snd = call i64 @calc_other(%Tuple* %inst)

        %vict = call i64 @points(%Tuple* %inst)

        %points_2 = add i64 %points, %vict
        %points_3 = add i64 %points_2, %snd
        %points_4 = add i64 %points_3, 1

        %chr = call i8 @advance(i8** %fn_ptr)
        %cond = icmp eq i8 %chr, 0
        br i1 %cond, label %end, label %loop
    end:
        call void @print_int(i64 %points_4)
        ret i64 0
}

