open base

pred LoginNoSistema[
	usernameInput, 
	emailInput, 
	senhaInput: one String,
	usuarioCadastrado: Usuario,
	sistema: Sistema] 
{
	usernameInput 	 != "STRING VAZIA" &&
	emailInput		 != "STRING VAZIA" &&
	senhaInput 	 != "STRING VAZIA" &&
	usuarioCadastrado in sistema.usuarios &&
	(usuarioCadastrado.username = usernameInput || usuarioCadastrado.email = emailInput) &&
	usuarioCadastrado.senha = senhaInput
}

run {
	one sistema: Sistema | 
	some usuarioCadastrado: Usuario | 
	some usuarioNaoCadastrado : Usuario |
	usuarioNaoCadastrado !in sistema.usuarios &&
	usuarioCadastrado in sistema.usuarios &&
	LoginNoSistema["userValido", "emailValido", "senhaValida", usuarioCadastrado, sistema] &&
	not LoginNoSistema["userValido", "emailValido", "STRING VAZIA", usuarioCadastrado, sistema] &&
	not LoginNoSistema["userValido", "STRING VAZIA", "senhaValida", usuarioCadastrado, sistema] &&
	not LoginNoSistema["STRING VAZIA", "emailValido", "senhaValida", usuarioCadastrado, sistema] &&
	not LoginNoSistema["userValido", "emailValido", "senhaValida", usuarioNaoCadastrado, sistema]
} for 3
