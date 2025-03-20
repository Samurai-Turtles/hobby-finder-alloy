// Sistema

one sig Sistema {
	usuarios: set Usuario
}

// Entidades

sig Usuario {
	username: one String,
	nome:	one String,
	email:	one String,
	senha:	one String
}

// Predicados

pred CadastroNoSistema[
	inputUser, 
	inputNome, 
	inputEmail, 
	inputSenha, 
	inputConfirmacao : one String,
	sistema: Sistema] {
	
	// Verifica inputs do formulário de cadastro
	not (no inputUser)
	not (no inputNome) 
	not (no inputEmail)
	not (no inputSenha)
	not (no inputConfirmacao)

	// Verifica fluxo correto de cadastro
	(inputConfirmacao = inputSenha) => {
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



// Fatos

fact UsuarioNoSistema {
	all u:Usuario | one s:Sistema | u in s.usuarios
}

fact NaoPodeMesmoUserName {
	all usuario1, usuario2: Usuario | 
		usuario1 != usuario2 => usuario1.nome != usuario2.nome
}

// Rodadas

run {
	one s: Sistema |
	CadastroNoSistema["nickNameValido", "Nome Válido", "email@valido.com", "senhaValida", "senhaValida", s]
	&& CadastroNoSistema["nickNameValido", "Nome Válido", "email@valido.com", "senhaValida", "senhaInValida", s]
} for 3
