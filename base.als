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

// Fatos base

fact NaoPodeMesmoUserName {
	all usuario1, usuario2: Usuario | all sistema: Sistema |
		(usuario1 in sistema.usuarios && usuario2 in sistema.usuarios) => 
		(usuario1 != usuario2 => usuario1.username != usuario2.username)
}
