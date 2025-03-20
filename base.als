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

fact UsuarioNoSistema {
	all u:Usuario | one s:Sistema | u in s.usuarios
}

fact NaoPodeMesmoUserName {
	all usuario1, usuario2: Usuario | 
		usuario1 != usuario2 => usuario1.nome != usuario2.nome
}
