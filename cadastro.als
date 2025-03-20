open base

pred CadastroNoSistema[
	inputUser, 
	inputNome, 
	inputEmail, 
	inputSenha, 
	inputConfirmacao : one String,
	sistema: Sistema] {
	
	// Verifica inputs do formulário de cadastro
	inputUser 			!= "STRING VAZIA" &&
	inputNome 		!= "STRING VAZIA" &&
	inputEmail 			!= "STRING VAZIA" &&
	inputSenha		 	!= "STRING VAZIA" &&
	inputConfirmacao 	!= "STRING VAZIA" &&

	// Verifica fluxo correto de cadastro
	inputConfirmacao  = inputSenha && {
		one usuarioACadastrar: Usuario | all usuarioNoSistema: Usuario |
			usuarioACadastrar in sistema.usuarios 			&&
			inputConfirmacao 		 	= inputSenha 	&&
			usuarioACadastrar.username 	= inputUser	&&
			usuarioACadastrar.nome 	 	= inputNome 	&&
			usuarioACadastrar.email 	 	= inputEmail 	&&
			usuarioACadastrar.senha 	 	= inputSenha	&&
			(usuarioNoSistema != usuarioACadastrar) => {
				usuarioACadastrar.username != usuarioNoSistema.username
			}
	}
}

run {
	one s: Sistema |
	CadastroNoSistema["nickNameValido", "Nome Válido", "email@valido.com", "senhaValida", "senhaValida", s]
	&& not CadastroNoSistema["nickNameValido", "Nome Válido", "email@valido.com", "senhaValida", "senhaInValida", s]
	&& not CadastroNoSistema["nickNameValido", "Nome Válido", "email@valido.com", "senhaValida", "STRING VAZIA", s]
	&& not CadastroNoSistema["nickNameValido", "Nome Válido", "email@valido.com", "STRING VAZIA", "senhaValida", s]
	&& not CadastroNoSistema["nickNameValido", "Nome Válido", "STRING VAZIA", "senhaValida", "senhaValida", s]
	&& not CadastroNoSistema["nickNameValido", "STRING VAZIA", "email@valido.com", "senhaValida", "senhaValida", s]
	&& not CadastroNoSistema["STRING VAZIA", "Nome Válido", "email@valido.com", "senhaValida", "senhaValida", s] 
} for 3
