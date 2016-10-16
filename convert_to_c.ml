# load "str.cma";;
# use "interpreter.ml" ;;

let print_to_c_file str = 
	let oc = (open_out "out.c") in
		Printf.fprintf oc ("%s\n") ("#include<stdio.h>\nint main(int argc, char *argv[]){\n\tint counter = 1;\n"^str^"}");
		close_out oc;
;;

(*returns a string representing the whole program*)
let rec convert_sl (stmt_l:ast_sl) = 
	let rec helper (init_str:string) l =  
		match l with
		| [] 	 -> init_str
		| hd::tl -> helper (init_str^"\n"^(convert_stmt hd)) tl 
		| _ -> raise(Failure "convert_to_c: unexpected error") in 
	helper "" stmt_l
(*return a string representing the statement*)
and convert_stmt (stmt:ast_s) = 
	match stmt with
	| AST_assign (id, expr) -> ("\tint "^id^" = "^(convert_expr expr)^";\n")
	| AST_read(id) -> ("\tint "^id^" = atoi(argv[counter]); \n\tcounter++; \n")
	| AST_write(expr) -> ("\t"^"printf(\"%d \", "^(convert_expr expr)^");\n")
	| AST_if(cond, sl) -> ("\t"^"if ("^(convert_expr cond)^") {\n\t"^(convert_sl sl)^"\n}\n")
	| AST_do(sl) -> (match sl with
					| hd::tl -> (match hd with
								| AST_check(cond) -> ("\t"^"while ("^(convert_expr cond)^") {\n"^(convert_sl tl)^"\n}\n")
								| _ -> ("\t"^"while (true) {\n"^(convert_sl sl)^"\n}\n"))
					| [] -> " "
					| _ -> raise(Failure "convert_stmt: unexpected error"))
	| _ -> raise(Failure "convert_stmt: unexpected error")

(*return a string representing the expression*)
and convert_expr (expr:ast_e) = 
	match expr with
	| AST_id(id) -> (id^" ")
	| AST_num(num) -> (num^" ")
	| AST_binop(op, lhs, rhs) -> ((convert_expr lhs)^op^" "^(convert_expr rhs))
	| _ -> raise(Failure "convert_expr: unexpected error")

(*main*)
let run_program = 
	let str = convert_sl sum_ave_syntax_tree in 
		print_to_c_file str;
;;
