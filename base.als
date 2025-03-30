open util_types

// Sistema

one sig Sistema {
	usuarios: set Usuario,
	eventos:  set Evento
}

// Entidades

sig Usuario {
	username: 		one Texto,
	nome:		one Texto,
	email:		one Texto,
	senha:		one Texto,
	descricao:		lone Texto,
	foto:			lone Foto,
	interesses:		set Interesse,
	solicitacoes: 	set Solicitacao,
	participacoes: 	set Participacao,
	notificacoes:	set Notificacao,
	notaGeral:		one Float
}

sig Evento {
	nomeEvento: 	     	one Texto,
	dataInicio: 	    	     	one Data,
	dataFim:        	     	one Data ,
	local: 		     	one Local,
	privacidade:   	     	one Privacidade,
	decricao: 	    	     	one Texto,
	fotos:			     	set Foto,
	capacidadeMaxima: 	one Int,
	solicitacoes: 	    	set Solicitacao,
	participacoes: 	   	set Participacao,
	interesse:			one Interesse,
	proprietario:		one Usuario
}

sig Solicitacao {
	usuario:	one Usuario,
	evento:	one Evento
}

sig Participacao {
	usuario:	one Usuario,
	evento: 	one Evento,
	cargo:	one Cargo,
	avaliacao:  lone Avaliacao
}

sig Avaliacao {
	estrelas: 		one Int,
	mensagem: 	lone Texto
}

sig Notificacao {
	mensagem: one Texto
}

sig Local {
	rua:		one Texto,
	distrito: 	one Texto,
	numero: 	one Texto,
	cidade: 	one Texto,
	estado: 	one Texto,
	latitude: 	one Float,
	longitude: 	one Float
}

sig Foto {}

// Entidades Utilitárias

abstract sig Interesse {}

one sig Geek, Esporte, Outros extends Interesse {}

abstract sig Cargo {}

one sig Criador, Organizador, Participante extends Cargo {}

abstract sig Privacidade {}

one sig Privado, Publico extends Privacidade {}

// Fatos base

fact TodoUsuarioEstaNoSistema {
	all usuario: Usuario | some sistema: Sistema | usuario in sistema.usuarios
}

fact NaoPodeMesmoUserName {
	all usuario1, usuario2: Usuario | all sistema: Sistema |
		(usuario1 in sistema.usuarios && usuario2 in sistema.usuarios) => 
		(usuario1 != usuario2 => usuario1.username != usuario2.username)
}

fact TodoEventoEstaNoSistema {
	all evento: Evento | some sistema: Sistema | evento in sistema.eventos
}

fact TodaNotificacaoEstaNoUsuario {
	all notificacao: Notificacao | one usuario: Usuario |
		notificacao in usuario.notificacoes
}

fact NotificacaoUnicaPorCadaUsuario {
	all usuario1, usuario2: Usuario | all notificacao: Notificacao |
		(usuario1 != usuario2 && notificacao in usuario1.notificacoes) =>
			notificacao !in usuario2.notificacoes 
}

fact TodoLocalEstaEmUmEvento {
	all localCadastrado: Local | some eventoCadastrado: Evento |
		eventoCadastrado.local = localCadastrado
}

fact TodaFotoEstaEmUmEventoOuUsuario {
	all fotoCadastrada: Foto | some eventoCadastrado: Evento, usuarioCadastrado: Usuario |
		fotoCadastrada in eventoCadastrado.fotos || usuarioCadastrado.foto = fotoCadastrada
}

fact TodoCargoEstaEmUmaParticipacao {
	all cargoCadastrado: Cargo | some participacao: Participacao |
		cargoCadastrado = participacao.cargo
}

fact todaAvaliacaoEstaEmUmaParticipacao {
	all avaliacaoCadastrada: Avaliacao | one participacao: Participacao |
		avaliacaoCadastrada = participacao.avaliacao
}

fact TodaSolicitacaoPossuiUmUsuarioEUmEvento {
	all solicitacao: Solicitacao | one usuarioCadastrado: Usuario, eventoCadastrado: Evento |
		solicitacao.usuario = usuarioCadastrado && solicitacao.evento = eventoCadastrado
}

fact TodaSolicitacaoTemUmParUnicoDeEventoUsuario {
	all solicitacao1, solicitacao2: Solicitacao | 
		(solicitacao1 != solicitacao2) => 
			solicitacao1.usuario != solicitacao2.usuario || solicitacao1.evento != solicitacao2.evento
}

fact TodaSolicitacaoEstaNoSeuUsuario {
	all solicitacao: Solicitacao | all usuarioCadastrado: Usuario | 
		(solicitacao.usuario = usuarioCadastrado) =>
			solicitacao in usuarioCadastrado.solicitacoes
}

fact UsuarioSoContemSuasSolicitacoes {
	all solicitacao: Solicitacao | all usuarioCadastrado: Usuario | 
		(solicitacao in usuarioCadastrado.solicitacoes) =>
			solicitacao.usuario = usuarioCadastrado
}

fact TodaSolicitacaoEstaNoSeuEvento {
	all solicitacao: Solicitacao | all eventoCadastrado: Evento | 
		(solicitacao.evento = eventoCadastrado) =>
			solicitacao in eventoCadastrado.solicitacoes
}

fact EventoSoContemSuasSolicitacoes {
	all solicitacao: Solicitacao | all eventoCadastrado: Evento | 
		(solicitacao in eventoCadastrado.solicitacoes) =>
			solicitacao.evento = eventoCadastrado
}

fact TodaParticipacaoPossuiUmUsuarioEUmEvento {
	all participacao: Participacao | one usuarioCadastrado: Usuario, eventoCadastrado: Evento |
		participacao.usuario = usuarioCadastrado && participacao.evento = eventoCadastrado
}

fact TodaParticipacaoTemUmParUnicoDeEventoUsuario {
	all participacao1, participacao2: Participacao | 
		(participacao1 != participacao2) => 
			participacao1.usuario != participacao2.usuario || participacao1.evento != participacao2.evento
}

fact TodaParticipacaoEstaNoSeuUsuario {
	all participacao: Participacao | all usuarioCadastrado: Usuario | 
		(participacao.usuario = usuarioCadastrado) =>
			participacao in usuarioCadastrado.participacoes
}

fact UsuarioSoContemSuasParticipacoes {
	all participacao: Participacao | all usuarioCadastrado: Usuario | 
		(participacao in usuarioCadastrado.participacoes) =>
			participacao.usuario = usuarioCadastrado
}

fact TodaParticipacaoEstaNoSeuEvento {
	all participacao: Participacao | all eventoCadastrado: Evento | 
		(participacao.evento = eventoCadastrado) =>
			participacao in eventoCadastrado.participacoes
}

fact EventoSoContemSuasParticipacoes {
	all participacao: Participacao | all eventoCadastrado: Evento | 
		(participacao in eventoCadastrado.participacoes) =>
			participacao.evento = eventoCadastrado
}

run {
	#Usuario = 5
	#Evento = 5
	#Notificacao = 5
	#Participacao = 3
	#Solicitacao = 2
	#Foto = 3
	#Avaliacao = 3
} for 20
