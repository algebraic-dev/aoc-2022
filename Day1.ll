@variable = global i32 233

declare i8* @read_file(i8*)
declare void @print_int(i64)

@.name = constant [6 x i8] c"input\00"

define i64 @read_number(i8** %place) {
    entry:
        br label %loop
    loop:
        %i = phi i64 [ 0, %entry ], [ %inc2, %next ]

        %ptr_1 = load i8*, i8** %place
        %ptr_2 = getelementptr i8, i8* %ptr_1, i64 1
        store i8* %ptr_2, i8** %place
        %chr   = load i8, i8* %ptr_1

        %cond  = icmp eq i8 %chr, 10
        %cond2 = icmp eq i8 %chr, 0
        %cond3 = or i1 %cond, %cond2
        br i1 %cond3, label %end, label %next
    next:
        %sub0 = sub i8 %chr, 48
        %sub  = zext i8 %sub0 to i64 
        %inc  = mul i64 %i, 10
        %inc2 = add i64 %inc, %sub

        br label %loop
    end:
        ret i64 %i
}

define i64 @main() {
    entry:
        %0 = bitcast [6 x i8]* @.name to i8*
        %1 = call i8* @read_file(i8* %0)

        %fn_ptr = alloca i8*, align 8
        store i8* %1, i8** %fn_ptr

        %max = alloca i64, align 8
        store i64 0, i64* %max

        %max2 = alloca i64, align 8
        store i64 0, i64* %max2

        %max3 = alloca i64, align 8
        store i64 0, i64* %max3

        %cur = alloca i64, align 8
        store i64 0, i64* %cur

        br label %loop
    loop: 
        %ptr_1 = load i8*, i8** %fn_ptr
        %chr   = load i8, i8* %ptr_1
        %cond = icmp eq i8 %chr, 10
        br i1 %cond, label %update, label %check_end
    
    ; eu deveria estar usando um array :c mas só quero terminar

    update:
        %cur_val   = load i64, i64* %cur
        %max_val_0 = load i64, i64* %max
        %cond1_0   = icmp ugt i64 %cur_val, %max_val_0
        br i1 %cond1_0, label %update1, label %update_x

    update1:
        %max_val_1 = load i64, i64* %max2
        %cond1_1   = icmp ugt i64 %cur_val, %max_val_1
        br i1 %cond1_1, label %update2, label %update1_ok

    update1_ok:
        store i64 %cur_val, i64* %max
        br label %update_x

    update2:
        %max_val_2 = load i64, i64* %max3
        %cond1_2   = icmp ugt i64 %cur_val, %max_val_2
        br i1 %cond1_2, label %update3, label %update2_ok

    update2_ok:
        store i64 %max_val_1, i64* %max
        store i64 %cur_val, i64* %max2
        br label %update_x

    update3:
        store i64 %max_val_1, i64* %max
        store i64 %max_val_2, i64* %max2
        store i64 %cur_val, i64* %max3
        br label %update_x

    update_x:
        store i64 0, i64* %cur
        %ptr_12 = load i8*, i8** %fn_ptr
        %ptr_22 = getelementptr i8, i8* %ptr_12, i64 1
        store i8* %ptr_22, i8** %fn_ptr
        br label %next
    check_end:
        %cond2 = icmp eq i8 %chr, 0
        br i1 %cond2, label %end, label %next
    next:
        %res = call i64 @read_number(i8** %fn_ptr)
        %cur2 = load i64, i64* %cur
        %cur3 = add i64 %cur2, %res
        store i64 %cur3, i64* %cur
        br label %loop    
    end:

        %max_val2 = load i64, i64* %max
        %max_val23 = load i64, i64* %max2
        %max_val24 = load i64, i64* %max3

        %add_0 = add i64 %max_val2, %max_val23
        %add_1 = add i64 %add_0, %max_val24

        call void @print_int(i64 %add_1)

        ret i64 0
}

