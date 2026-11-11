extends CanvasLayer

const CENA := preload("res://game/dialogScrim.tscn")

const PERSONAGENS := {
	"xerife": {"nome": "Xerife", "retrato": "res://sprite_00.png"},
	"vendedor": {"nome": "Vendedor de Armas", "retrato": "res://sprite_15.png"},
	"granger": {"nome": "Sr. Granger", "retrato": "res://sprite_8.png"},
	"doutor": {"nome": "Doutor", "retrato": "res://game/sprite_11.png"},
	"sra_bell": {"nome": "Sra. Bell", "retrato": "res://game/sprite_14.png"},
	"sr_bell": {"nome": "Sr. Bell", "retrato": "res://game/characters/Sr. Bell.png"},
	"barista": {"nome": "Barista", "retrato": "res://game/sprite_8.png"},
	"bancario": {"nome": "Bancário", "retrato": "res://bancoo.png"},
	"vice": {"nome": "Vice Xerife", "retrato": ""},
	"charlotte": {"nome": "Charlotte Bell", "retrato": "res://game/sprite_10.png"},
	"julie": {"nome": "Julie", "retrato": "res://game/sprite_10.png"},
}

const GRUPOS := {
	"casa_bell": {
		"flags": [
			"casa_corpo", "casa_cama_filha", "casa_armario", "casa_janela",
			"casa_cama_pais", "casa_mesa_sr", "casa_mesa_sra", "casa_estante",
		],
		"conversa": "casa_fim",
		"cena": "res://game/hospital.tscn",
		"spawn": "entrada",
	},
	"granger_quarto": {
		"flags": ["granger_cama", "granger_armario", "granger_bau", "granger_mesa"],
		"conversa": "granger_fim",
	},
}

const ROTEIROS := {
	"estante_estacao": [
		{"requer": "arquivos_gangue", "conversa": "estante_com_arquivos"},
		{"conversa": "estante_sem_arquivos"},
	],
	"vendedor_1": [
		{"requer": "falou_vendedor_armas", "conversa": ""},
		{"conversa": "vendedor_1"},
	],
	"granger_1": [
		{"requer": "falou_granger", "conversa": ""},
		{"conversa": "granger_1"},
	],
	"barista_1": [
		{"requer": ["falou_barista", "barista_roxos"], "conversa": ""},
		{"conversa": "barista_1"},
	],
	"bancario_1": [
		{"requer": "falou_bancario", "conversa": ""},
		{"conversa": "bancario_1"},
	],
	"sra_bell_1": [
		{"requer": "falou_sra_bell", "conversa": ""},
		{"conversa": "sra_bell_1"},
	],
	"doutor_menu": [
		{"requer": ["doutor_conhecia", "doutor_bar"], "conversa": ""},
		{"conversa": "doutor_menu"},
	],
	"julie_1": [
		{"requer": "falou_julie", "conversa": ""},
		{"conversa": "julie_1"},
	],
}

const CONVERSAS := {

	"inicio": [
		["xerife", "O corpo está no andar de cima, no quarto da filha."],
		{"auto": 3.0},
	],

	"corpo_bell": [
		["xerife", "…"],
		["xerife", "Esse é o Senhor Bell. Marido, pai, e lutador da igualdade entre as raças."],
		["xerife", "…"],
		["xerife", "Eu me ajoelho e verifico o pulso dele."],
		["xerife", "…"],
		["xerife", "O corpo ainda está morno, mas não há nenhum sinal de vida, como esperado."],
		["xerife", "Eu me afasto um pouco e dou uma olhada mais ampla ao corpo."],
		["xerife", "No peito dele, há um orifício de bala."],
		["xerife", "Julgando pela profundidade da ferida, o atirador estava apenas a alguns metros de distância."],
		["xerife", "A bala também parece ter chegado no coração. A sua morte provavelmente foi instantânea."],
		["xerife", "…"],
		["xerife", "É só isso que eu consigo determinar."],
		["xerife", "Eu escrevo tudo isso no meu caderno, e arranco a página."],
		["xerife", "[i]Eu obtive a Autópsia do Sr. Bell[/i]"],
		{"item": "autopsia_sr_bell"},
		["xerife", "Eu deveria levá-lo ao doutor para uma autópsia completa."],
		["xerife", "Mas primeiro, eu preciso investigar essa casa, e tentar encontrar qualquer pista."],
		["xerife", "Principalmente com relação à menina, que está desaparecida."],
		{"flag": "casa_corpo"},
	],
	"cama_charlotte": [
		["xerife", "A cama está bem bagunçada. Como se alguém tivesse sido arrancado dela."],
		["xerife", "…"],
		{"flag": "casa_cama_filha"},
	],
	"armario_charlotte": [
		["xerife", "Esse armário está fechado."],
		["xerife", "Eu tento abri-lo."],
		["xerife", "…"],
		{"som": "armario_trancado"},
		["xerife", "Ele não abre. Nem à força."],
		{"flag": "casa_armario"},
	],
	"janela_charlotte": [
		["xerife", "A janela está aberta."],
		["xerife", "Eu tento olhar pra fora, mas não consigo ver nada no escuro."],
		{"flag": "casa_janela"},
	],

	"cama_pais": [
		["xerife", "É uma cama de casal. Ela está bem arrumada."],
		{"flag": "casa_cama_pais"},
	],
	"mesa_sr_bell": [
		["xerife", "Era aqui que o Sr. Bell escrevia as suas obras."],
		["xerife", "Há um papel meio escrito aqui. Ele diz o seguinte:"],
		["sr_bell", "“...nenhuma raça é geneticamente superior à outra.”"],
		["sr_bell", "“Portanto, o ódio que existe entre as raças é uma fabricação.”"],
		["sr_bell", "“É algo que mantém o povo distraído de problemas reais.”"],
		["sr_bell", "“É algo que faz as raças se culparem, e as mantém cegas da verdade.”"],
		["sr_bell", "“A verdade que o culpado é-”"],
		["xerife", "…"],
		["xerife", "O texto termina aqui."],
		["xerife", "[i]Eu obtive a Obra Incompleta[/i]"],
		{"item": "obra_incompleta"},
		{"flag": "casa_mesa_sr"},
	],
	"mesa_sra_bell": [
		["xerife", "Há um caderno aqui."],
		["xerife", "Folheando-o, parece que era aqui que a Família Bell organizava suas finanças."],
		["xerife", "…"],
		["xerife", "Aparentemente, filosofia não é algo lucrativo."],
		{"flag": "casa_mesa_sra"},
	],
	"estante_pais": [
		["xerife", "Há centenas de livros aqui. Desde ficção até filosofia."],
		["xerife", "Em particular, eu reparo nos livros escritos pelo Sr. e a Sra. Bell."],
		["xerife", "Obras argumentativas que proclamam a igualdade das raças…"],
		["xerife", "…e refutam argumentos racistas populares."],
		["xerife", "Se ao menos as pessoas lessem isso, nós viveríamos em um mundo melhor."],
		{"flag": "casa_estante"},
	],

	"casa_fim": [
		["xerife", "Acho que terminei de investigar a casa."],
		["xerife", "Que estranho… não há nenhum sinal de invasão…"],
		["xerife", "Como que o assassino poderia ter entrado?"],
		["xerife", "…"],
		["xerife", "Eu não tenho a menor ideia."],
		["xerife", "Por enquanto, vou levar o corpo ao doutor."],
		{"flag": "corpo_levado"},
	],

	"doutor_1": [
		["xerife", "Então? O que você acha?"],
		["doutor", "…"],
		["doutor", "Uma bala bem no coração. Julgando pela profundidade…"],
		["doutor", "…o atirador estava a uns cinco metros de distância."],
		["doutor", "Além disso, dê uma olhada na bala."],
		["doutor", "Eu retirei ela aqui. Pode pegar."],
		["xerife", "[i]Eu obtive a bala especial.[/i]"],
		{"item": "bala_especial"},
		["xerife", "…"],
		["xerife", "É uma .35 Escobar. Raríssima."],
		["xerife", "Só tem um lugar no estado inteiro que vende ela…"],
		["xerife", "A loja de armas aqui em Javelina."],
		["xerife", "…"],
		["xerife", "Eu deveria ir questionar o vendedor da loja de armas."],
		["doutor", "Eu também percebi que ele estava bêbado quando morreu."],
		["xerife", "Bêbado?"],
		["doutor", "Sim. Dá pra perceber pela vermelhidão no rosto dele."],
		["doutor", "Ele deve ter passado naquele bar depravado antes de morrer."],
		["doutor", "Nunca entendi porque um elfo roxo digno como o Sr. Bell frequentava um lugar daquele…"],
		["xerife", "…hm. Eu deveria ir investigar o bar."],
		["xerife", "…algo mais?"],
		["doutor", "Hmm… não. É só isso."],
		["xerife", "Obrigado, doutor."],
		["xerife", "A propósito, você sabe onde está a Sra. Bell? Ela foi a primeira a achar o corpo."],
		["doutor", "Ela está naquela… igreja dos elfos verdes, eu acho."],
		["xerife", "…entendi."],
		{"flag": "falou_doutor"},
		{"opcoes": [
			{"texto": "Quão bem você conhecia o Sr. Bell?", "conversa": "doutor_conhecia", "volta": true, "oculta_se": "doutor_conhecia"},
			{"texto": "Qual é o seu problema com o bar?", "conversa": "doutor_bar", "volta": true, "oculta_se": "doutor_bar"},
			{"texto": "Obrigado pela ajuda. Até mais.", "conversa": ""},
		]},
	],
	"doutor_menu": [
		["doutor", "…"],
		{"opcoes": [
			{"texto": "Quão bem você conhecia o Sr. Bell?", "conversa": "doutor_conhecia", "volta": true, "oculta_se": "doutor_conhecia"},
			{"texto": "Qual é o seu problema com o bar?", "conversa": "doutor_bar", "volta": true, "oculta_se": "doutor_bar"},
			{"texto": "Obrigado pela ajuda. Até mais.", "conversa": ""},
		]},
	],
	"doutor_conhecia": [
		["doutor", "Não muito, para falar a verdade."],
		["doutor", "Claro que eu ouvia falar dele desde pequeno…"],
		["doutor", "Igual todo elfo roxo nesta cidade."],
		["doutor", "O herdeiro abandonado da família Cortez…"],
		["doutor", "Mas ele só passou aqui algumas vezes, por pequenas emergências médicas."],
		["doutor", "Naturalmente, eu nunca vi a filha dele. Igual todo mundo nessa cidade."],
		["xerife", "Entendi. E a Sra. Bell?"],
		["doutor", "Claro que não! Eu não atendo elfos verdes!"],
		["xerife", "…hã."],
		["doutor", "…mesmo assim, eu já li algumas obras deles."],
		["doutor", "Aquela teoria sobre “igualdade de raças” é um absurdo."],
		["doutor", "Elfos roxos e verdes são extremamente diferentes!"],
		["doutor", "Na verdade, é cientificamente comprovado que elfos roxos são superiores aos verdes…"],
		["doutor", "Estudos dizem que nós somos mais inteligentes, fortes e atléticos!"],
		["xerife", "…"],
		["doutor", "Porém, eu concordo com as teorias econômicas deles."],
		["doutor", "Trabalhadores precisam de muitas mais proteções."],
		["doutor", "Eu mesmo… trabalhava nas minas quando era criança…"],
		["doutor", "Muitos dos meus irmãos morreram lá…"],
		["doutor", "…"],
		["doutor", "Felizmente, eu mudei de carreira, mas tenho muita simpatia para todos que sofrem lá."],
		["doutor", "…"],
		["doutor", "…e gente rica tem que se ferrar mesmo!"],
		{"flag": "doutor_conhecia"},
	],
	"doutor_bar": [
		["doutor", "É um lugar de propriedade de um elfo verde!"],
		["doutor", "Me dá nojo só de pensar em entrar nele!"],
		{"flag": "doutor_bar"},
	],

	"vendedor_1": [
		["vendedor", "Boa noite, xerife. Como posso ajudar?"],
		{"opcoes": [
			{"texto": "O que você pode me dizer sobre essa bala?", "conversa": "vendedor_bala", "oculta_se": "falou_vendedor_armas"},
			{"texto": "Obrigado pela ajuda. Até mais.", "conversa": ""},
		]},
	],
	"vendedor_bala": [
		["vendedor", "Uma .35 Escobar?"],
		["xerife", "Isso. Ela foi encontrada no coração do Sr. Bell."],
		["vendedor", "Caramba…"],
		["xerife", "Pelo o que eu sei, você vende essa bala aqui, correto?"],
		["vendedor", "Sim. Na verdade, essa é a única loja na região que vende ela."],
		["vendedor", "Bem rara. Ela não é vendida nem na cidade grande."],
		["xerife", "Eu sei. E pra quem você já vendeu essa bala?"],
		["vendedor", "Para turistas, em maior parte. Tem gente que vem pra Javelina só pra comprar ela."],
		["vendedor", "O que é engraçado, já que não tem nada de especial sobre ela além do nome."],
		["vendedor", "Eu consigo cobrar mais, mesmo que ela seja idêntica a uma bala normal!"],
		["xerife", "Hm…"],
		["xerife", "E você já vendeu ela para alguém que mora aqui em Javelina?"],
		["vendedor", "Só pra uma pessoa. O Sr. Granger."],
		["xerife", "…o dono da loja de variedades?"],
		["vendedor", "Ele mesmo."],
		["xerife", "Por que ele comprou essa bala, e não uma bala normal?"],
		["vendedor", "Eu convenci ele."],
		["xerife", "Convenceu?"],
		["vendedor", "Isso."],
		["vendedor", "Ele queria comprar mais munição… e eu… hã… [i]sugeri[/i] que ele comprasse essa."],
		["vendedor", "…ha! Elfo verde é burro mesmo."],
		["xerife", "…"],
		["xerife", "…bem, então ele é o único suspeito que eu tenho até agora."],
		["xerife", "Vou ter que fazer algumas perguntas pra ele."],
		["vendedor", "Que bom. Tem algo muito suspeito sobre aquele homem…"],
		["vendedor", "Só por precaução, pegue o comprovante da compra. Eu guardei ele."],
		["xerife", "Boa ideia. Muito obrigado."],
		["vendedor", "[i]Eu obtive o comprovante[/i]"],
		{"item": "comprovante"},
		{"flag": "falou_vendedor_armas"},
	],

	"granger_1": [
		["granger", "Olá, xerife! Como vai?"],
		{"opcoes": [
			{"texto": "Você sabe alguma coisa sobre essa bala?", "conversa": "granger_bala", "requer": "falou_vendedor_armas", "oculta_se": "falou_granger"},
			{"texto": "Obrigado pela ajuda. Até mais.", "conversa": ""},
		]},
	],
	"granger_bala": [
		["granger", "Hã..?"],
		["granger", "…ela se parece com a bala que eu tenho."],
		["xerife", "Você é a única pessoa em Javelina inteira que comprou essa bala."],
		["granger", "S-sério?"],
		["xerife", "…você pode me mostrar sua arma?"],
		["granger", "N-na verdade… eu perdi a minha arma…"],
		["xerife", "…"],
		["xerife", "E porque você não reportou isso pra polícia?"],
		["granger", "E-eu… n-não tive tempo…"],
		["granger", "E-ela só sumiu algumas horas atrás!"],
		["xerife", "…"],
		["xerife", "Como que ela sumiu? Me conte a história inteira."],
		["granger", "B-bem… não tem muito o que falar…"],
		["granger", "Por volta das seis horas da tarde, eu fui conferir o baú no meu quarto…"],
		["granger", "…que é onde eu coloco meu revólver…"],
		["granger", "Mas ele tinha simplesmente desaparecido!"],
		["xerife", "…"],
		["xerife", "Eu posso dar uma olhada no seu quarto?"],
		["granger", "Hã.. porque?"],
		["xerife", "Se alguém roubou a sua arma, eu devo investigar, certo?"],
		["granger", "C-certíssimo, meu xerife! Pode pegar a chave do meu quarto aqui!!"],
		["xerife", "[i]Eu obtive a Chave do Sr. Granger[/i]"],
		{"item": "chave_granger"},
		["granger", "Espero que você ache alguma coisa!!!"],
		{"flag": "falou_granger"},
	],
	"julie_1": [
		["xerife", "Olá."],
		{"flag": "falou_julie"},
	],

	"granger_cama": [
		["xerife", "É só uma cama de casal… não parece nada especial…"],
		["xerife", "…"],
		["xerife", "…?"],
		["xerife", "Em baixo da cama, eu estou vendo alguma coisa…"],
		["xerife", "…uma chave?"],
		["xerife", "[i]Você obteve a Chave Dourada[/i]"],
		{"item": "chave_dourada"},
		{"flag": "granger_cama"},
	],
	"granger_armario": [
		["xerife", "Esse armário está fechado."],
		["xerife", "Eu tento abri-lo."],
		["xerife", "…"],
		{"som": "armario_trancado"},
		["xerife", "Ele não abre. Nem à força."],
		{"flag": "granger_armario"},
	],
	"granger_bau": [
		["xerife", "Acho que esse é o baú onde a arma estava."],
		["xerife", "Eu abro ele."],
		["xerife", "…"],
		["xerife", "Ele está completamente vazio."],
		{"flag": "granger_bau"},
	],
	"granger_mesa": [
		["xerife", "Eu abro a gaveta."],
		["xerife", "…"],
		["xerife", "Nada notável aqui."],
		{"flag": "granger_mesa"},
	],
	"granger_fim": [
		["xerife", "Não achei nada aqui… só essa chave…"],
		["xerife", "O que será que ela abre?"],
	],

	"barista_1": [
		["barista", "Olá, xerife."],
		["barista", "…é sobre o Sr. Bell?"],
		{"opcoes": [
			{"texto": "Sim. O Sr. Bell passou aqui nesta noite?", "conversa": "barista_noite", "oculta_se": "falou_barista"},
			{"texto": "Eu pensava que elfos roxos não podiam entrar aqui…", "conversa": "barista_roxos", "volta": true, "oculta_se": "barista_roxos"},
			{"texto": "Obrigado pela ajuda. Até mais.", "conversa": ""},
		]},
	],
	"barista_noite": [
		["barista", "Sim… ele e a esposa dele estavam aqui."],
		["xerife", "A esposa também? Hm…"],
		["xerife", "Pode me falar o que eles fizeram aqui?"],
		["barista", "Eles vieram aqui, beberam um pouco… o Sr. Bell mais do que um pouco…"],
		["barista", "Eles estavam discutindo alguma coisa sobre a filha deles, como sempre."],
		["barista", "Eventualmente, o Sr. Bell foi embora. Não muito tempo depois…"],
		["barista", "…ouvimos um tiro… vindo da casa da família Bell…"],
		["xerife", "…entendi."],
		["xerife", "E o que eles estavam discutindo, exatamente?"],
		["barista", "Sobre um potencial casamento da filha deles."],
		["barista", "Veja, eles estão em uma situação complicada…"],
		["barista", "A Charlotte não pode se casar com um elfo verde ou roxo."],
		["barista", "Já que isso indicaria que os pais dela estariam… “escolhendo um lado”."],
		["barista", "Então, existem duas opções."],
		["barista", "A Sra. Bell não quer deixar a Charlotte se casar com ninguém."],
		["barista", "Enquanto o Sr. Bell sugeriu arranjar um casamento…"],
		["barista", "…com você, meu xerife!"],
		["xerife", "Hã? Por que eu?"],
		["barista", "Ué, porque você é um humano, igual a Charlotte."],
		["barista", "Na verdade, você é o único outro humano nessa cidade."],
		["xerife", "…e porque a menina não pode escolher com quem ela vai casar?"],
		["barista", "Ha! Nunca que isso vai acontecer. Eles não deixam ela nem sair de casa."],
		["barista", "Pessoalmente, eu ofereci o meu filho pra eles, mas eles rejeitaram…"],
		["barista", "Mas se eles fossem espertos, aquela Charlotte se casaria com um elfo verde."],
		["xerife", "...estamos fugindo do tópico agora. Sobre o que aconteceu nessa noite…"],
		["barista", "Ah, sim."],
		["barista", "Depois desse argumento todo, o Sr. Bell foi embora."],
		["barista", "Ele falou que ia passar no banco, e então ir pra casa."],
		["xerife", "Hm…"],
		["xerife", "Vou ter que ir investigar o banco então. Obrigado pela informação."],
		["barista", "Não há de que."],
		["barista", "Quer saber… pegue uma cerveja. À conta da casa."],
		["xerife", "[i]Eu obtive A Cerveja[/i]"],
		{"item": "cerveja"},
		{"flag": "falou_barista"},
	],
	"barista_roxos": [
		["barista", "Isso é verdade."],
		["barista", "…então por que o Sr. Bell estava aqui?"],
		["barista", "Ah, bem… o Sr. Bell é uma exceção. Por cortesia da Sra. Bell"],
		["barista", "Veja, logo depois de eles se casarem e se mudarem pra aquela casa enorme deles…"],
		["barista", "A Sra. Bell veio aqui e… [i]insistiu[/i] que o Sr. Bell pudesse atender esse bar."],
		["barista", "A própria ideia disso me dava nojo, mas…"],
		["barista", "Nós chegamos em um acordo."],
		["barista", "O Sr. Bell poderia beber aqui, mas ele paga três vezes a mais nas suas bebidas."],
		["barista", "Além disso, se ele fizesse qualquer besteira, eu expulsaria ele daqui."],
		["barista", "…"],
		["barista", "…mas ele sempre foi um homem respeitoso."],
		["barista", "Principalmente para um elfo verde."],
		["barista", "…ele era um dos bons."],
		{"flag": "barista_roxos"},
	],

	# ======================= BANCO =======================
	"bancario_1": [
		["bancario", "…"],
		["xerife", "…boa noite."],
		["bancario", "Boa noite."],
		["bancario", "…é sobre o Sr. Bell?"],
		["xerife", "Sim."],
		{"opcoes": [
			{"texto": "Eu ouvi que o Sr. Bell passou aqui antes de morrer.", "conversa": "bancario_bell", "requer": "falou_barista", "oculta_se": "falou_bancario"},
			{"texto": "Obrigado pela ajuda. Até mais.", "conversa": ""},
		]},
	],
	"bancario_bell": [
		["bancario", "Sim. Ele passou aqui, consideravelmente bêbado."],
		["bancario", "Ele queria apenas retirar dinheiro."],
		["xerife", "…só isso?"],
		["bancario", "Sim. Porém, ele saiu antes de terminar o retiro."],
		["xerife", "E por que ele fez isso?"],
		["bancario", "Então… ontem, a filha dele passou aqui no banco."],
		["bancario", "Essa foi a única vez na vida que eu vi ela."],
		["bancario", "Ela me pediu dinheiro da conta dos pais, o que eu me recusei a fazer…"],
		["bancario", "Naturalmente, eu contei isso para o Sr. Bell quando ele veio aqui retirar dinheiro."],
		["bancario", "Ele ficou furioso e saiu correndo daqui."],
		["bancario", "…uns dez minutos depois… eu ouvi o tiro."],
		["xerife", "…obrigado pela informação, senhor."],
		["bancario", "E não é só isso…"],
		["bancario", "Depois de ouvir o tiro, eu saí pra ver o que estava acontecendo, igual todo mundo."],
		["bancario", "Aparentemente, o meu assistente viu algo interessante…"],
		["bancario", "Durante a confusão, ele viu duas pessoas suspeitas entrando na estação de trem…"],
		["bancario", "Ele até tirou uma foto. Veja aqui."],
		["xerife", "[i]Eu obtive a Foto dos Suspeitos[/i]"],
		{"item": "foto_suspeitos"},
		["xerife", "…"],
		["xerife", "Está muito escuro pra identificar quem é…"],
		["bancario", "Quando nós tentamos entrar lá, a porta estava trancada."],
		["xerife", "…talvez dê pra entrar pela janela…"],
		["xerife", "Obrigado. Eu vou ter que investigar a estação de trem."],
		{"flag": ["falou_bancario", "sabe_duas_pessoas"]},
	],

	"sra_bell_1": [
		["sra_bell", "…"],
		{"opcoes": [
			{"texto": "Olá, senhora. Você pode responder algumas perguntas?", "conversa": "sra_bell_perguntas", "oculta_se": "falou_sra_bell"},
			{"texto": "Obrigado pela ajuda. Até mais.", "conversa": ""},
		]},
	],
	"sra_bell_perguntas": [
		["sra_bell", "…"],
		["xerife", "Eu… eu não consigo nem imaginar a dor que você está sentindo."],
		["xerife", "Mas eu preciso trazer justiça."],
		["xerife", "Essa é a minha obrigação, e é o mínimo que eu posso fazer para você e sua família."],
		["sra_bell", "…"],
		["sra_bell", "…justiça não vai trazer ele de volta."],
		["xerife", "…"],
		["xerife", "Não, não vai. Mas a sua filha ainda está desaparecida."],
		["xerife", "…eu ainda posso encontrar ela. Ela provavelmente ainda está viva."],
		["sra_bell", "…"],
		["sra_bell", "…certo. O que você quer saber?"],
		["xerife", "Muito obrigado, senhora."],
		["xerife", "…você tem alguma ideia de quem fez isso? Alguém queria matar o seu marido?"],
		["sra_bell", "…"],
		["sra_bell", "Eu… tenho um palpite…"],
		["sra_bell", "…uma gangue."],
		["xerife", "…uma gangue?"],
		["sra_bell", "…sim. A Gangue Reyes."],
		["xerife", "…e o que eles tinham contra o seu marido?"],
		["sra_bell", "…eles são… elfos verdes supremacistas."],
		["sra_bell", "…o meu marido é roxo."],
		["xerife", "…entendi."],
		["xerife", "…"],
		["xerife", "…se eu não me engano, o xerife antigo tinha arquivos sobre as gangues de Javelina."],
		["xerife", "Lá no escritório."],
		["xerife", "Deve ter alguma coisa sobre essa gangue."],
		["xerife", "Hm."],
		["xerife", "…"],
		["xerife", "Obrigado. Aguente firme."],
		["sra_bell", "…"],
		{"flag": "falou_sra_bell"},
	],

	"cadeia_porta": [
		["xerife", "Eu pego a minha chave e destranco a porta…"],
		["xerife", "…"],
		{"som": "porta_destrancando"},
		{"flag": "cadeia_destrancada"},
	],
	"arquivos_gangue": [
		["xerife", "Eu abro a gaveta e me deparo com uma pilha de documentos."],
		["xerife", "Eu folheio-os, e eventualmente acho a página sobre a Gangue Reyes."],
		["xerife", "[i]Eu obtive os Arquivos da Gangue[/i]"],
		{"item": "arquivos_gangue"},
		["xerife", "…"],
		["xerife", "De acordo com esse papel, a gangue é uma organização relativamente grande…"],
		["xerife", "Baseada não apenas em Javelina, mas em vários lugares da região."],
		["xerife", "Eles só recrutam elfos verdes, e tem como alvo qualquer outra raça além de elfos verdes."],
		["xerife", "Aqui em Javelina, eles já assaltaram a loja de armas, o doutor, a estação de trem, e o banco quatro vezes…"],
		["xerife", "…e também várias casas de elfos roxos ao leste de Javelina."],
		["xerife", "Eles já tentaram assassinar o Sr. Bell duas vezes…"],
		["xerife", "…"],
		["xerife", "Eles se formaram como uma revolta dos elfos verdes."],
		["xerife", "Depois que o xerife antigo descobriu que o antigo recepcionista da estação de trem…"],
		["xerife", "…torturava e matava elfos verdes no porão escondido da estação."],
		["xerife", "Esse porão fica escondido atrás da estante de livros."],
		["xerife", "É só puxar o livro “O Manifesto da Igualdade” por Eva e Leonardo Bell, que a estante se move…"],
		["xerife", "E revela a porta à esse porão secreto."],
		["xerife", "A porta é aberta com uma chave dourada."],
		["xerife", "…"],
		["xerife", "…o documento acaba aqui."],
	],

	"estante_sem_arquivos": [
		["xerife", "Não tenho tempo de ler livros agora."],
	],
	"estante_com_arquivos": [
		["xerife", "De acordo com os arquivos, essa estante está escondendo uma porta secreta."],
		["xerife", "Eu puxo o livro especificado…"],
		{"som": "estante_deslizando"},
		{"flag": "estante_aberta"},
		["xerife", "[i]Eu obtive O Manifesto da Igualdade[/i]"],
		{"item": "manifesto_igualdade"},
		["xerife", "A estante de livros se moveu… e revelou uma porta…"],
	],
	"porao_trancada": [
		["xerife", "Eu tento abrir a porta…"],
		["xerife", "…"],
		{"som": "porta_trancada"},
		["xerife", "Ela está trancada."],
		["xerife", "Eu vou ter que achar a chave."],
	],
	"porao_chave": [
		["xerife", "Examinando a porta, eu noto que…"],
		["xerife", "O buraco da fechadura parece que é para…"],
		["xerife", "A chave dourada? Que eu achei na loja de variedades?"],
		["xerife", "Eu tento usar a chave para destrancar a porta…"],
		["xerife", "…"],
		{"som": "porta_destrancando"},
		["xerife", "Funcionou. Vamos ver o que está escondido aqui."],
		{"flag": "porao_destrancado"},
	],

	"charlotte_final": [
		["charlotte", "…hã?"],
		["charlotte", "X-xerife?"],
		["xerife", "Charlotte?!"],
		["xerife", "Você está bem?"],
		["charlotte", "E-estou…"],
		["xerife", "O que você está fazendo aqui?"],
		["charlotte", "E-eu…"],
		["charlotte", "…"],
		["xerife", "…está tudo bem. Deixa eu te levar até sua mãe. Ela está preocupada e-"],
		["charlotte", "N-não! Não faça isso, por favor."],
		["xerife", "…o que? Como assim? Por que?"],
		["charlotte", "…"],
		["charlotte", "Eu não… quero ver ela."],
		["xerife", "Não quer ver ela..?"],
		["charlotte", "…"],
		["charlotte", "…o que você está fazendo aqui?"],
		["xerife", "Procurando você. E o assassino do seu pai."],
		["charlotte", "…e você me encontrou. Parabéns."],
		["charlotte", "Mas eu me recuso a ver minha mãe."],
		["charlotte", "…"],
		["xerife", "O que aconteceu? Como que você veio parar aqui?"],
		["charlotte", "Bem, eu…"],
		["charlotte", "…"],
		["charlotte", "Alguns meses atrás, eu consegui fugir de casa pela primeira vez."],
		["charlotte", "Foi assim que eu conheci a Julie."],
		["charlotte", "Eu.. gostei dela."],
		["charlotte", "…agora, nós se vemos frequentemente."],
		["charlotte", "À noite, ela vem para minha casa, e entra no meu quarto pela janela."],
		["charlotte", "Nós… estávamos planejando em fugir. Para a cidade grande."],
		["charlotte", "Longe de Javelina. Longe dos meus pais. Longe dos pais dela."],
		["charlotte", "…"],
		["charlotte", "Hoje à noite, a Julie estava no meu quarto."],
		["charlotte", "Só que, hoje, o meu pai voltou pra casa mais cedo e mais bêbado do que o normal."],
		["charlotte", "Ele também estava irritado. Eu presumo que o bancário me dedurou."],
		["charlotte", "Quando ele veio pro meu quarto, eu…"],
		["charlotte", "…peguei a arma que a Julie havia trazido. O revólver do pai dela."],
		["charlotte", "Só que… e-ele…"],
		["charlotte", "…veio correndo a-até a minha direção."],
		["charlotte", "…"],
		["charlotte", "…eu não queria ter atirado nele, eu juro. E-eu entrei em pânico, e…"],
		["charlotte", "…"],
		["charlotte", "D-depois disso, eu e a Julie fugimos pra cá."],
		["charlotte", "Nós vamos pegar o trem amanhã de manhã e ir para a cidade grande."],
		["xerife", "…"],
		["xerife", "…e por que você quer fugir?"],
		["charlotte", "…"],
		["charlotte", "Eu não aguento mais morar naquela casa."],
		["charlotte", "Meus pais não me deixam sair de casa desde os oito anos."],
		["charlotte", "Eu quero explorar o mundo, conhecer pessoas…"],
		["charlotte", "Meus pais, eles…"],
		["charlotte", "Eles me veem só como um instrumento político."],
		["charlotte", "Como se fosse possível convencer o povo dessa cidade a fazer alguma coisa."],
		["charlotte", "Eles não ligam pra mim. Passam o dia inteiro escrevendo."],
		["charlotte", "Eu não posso fazer nada além de ler os mesmos livros estúpidos."],
		["charlotte", "Eu não aguento mais. Eu vou embora."],
		["charlotte", "A Julie também."],
		["charlotte", "Os pais dela arranjaram um casamento com algum fazendeiro…"],
		["charlotte", "Quando ela disse que não, ela apanhou…"],
		["charlotte", "Não existe gente decente nessa cidade."],
		["charlotte", "…"],
		["charlotte", "Por isso que nós queremos ir embora. Entendeu?"],
		["xerife", "…"],
		["xerife", "…eu entendo."],
		["charlotte", "O que?"],
		["xerife", "Eu simpatizo com a situação de vocês."],
		["xerife", "De acordo com a lei, eu deveria te prender. Você cometeu um assassinato."],
		["xerife", "Mas…"],
		["charlotte", "…"],
		["charlotte", "Isso não é justo."],
		["charlotte", "O justo é deixar vocês irem embora."],
		["xerife", "Saiam dessa cidade."],
		["charlotte", "…"],
		["charlotte", "…obrigada, xerife."],
		{"flag": "fim_do_jogo"},
	],
}

var ativo: bool = false
var _cena_apos := {}

func _ready() -> void:
	layer = 10

func falar(id_conversa: String) -> void:
	var id := resolver(id_conversa)
	if id == "":
		return
	if not CONVERSAS.has(id):
		push_warning("Conversa não cadastrada: " + id)
		return
	iniciar(montar(id))

func falar_e_ir(id_conversa: String, cena: String, spawn := "") -> void:
	if cena == "":
		push_warning("falar_e_ir sem cena de destino: " + id_conversa)
		falar(id_conversa)
		return
	_cena_apos = {"cena": cena, "spawn": spawn}
	falar(id_conversa)
	if not ativo:
		_cena_apos = {}

func resolver(id: String) -> String:
	if not ROTEIROS.has(id):
		return id
	for regra in ROTEIROS[id]:
		if not _todas(regra.get("requer", "")):
			continue
		var bloqueado: String = regra.get("bloqueado_por", "")
		if bloqueado != "" and Estado.tem(bloqueado):
			continue
		return str(regra["conversa"])
	return id


func disponivel(id: String) -> bool:
	return resolver(id) != ""


func _todas(valor: Variant) -> bool:
	var lista: Array = valor if valor is Array else [valor]
	for f in lista:
		if str(f) != "" and not Estado.tem(str(f)):
			return false
	return true

func fala(id: String, texto: String) -> Dictionary:
	if not PERSONAGENS.has(id):
		push_warning("Personagem não cadastrado: " + id)
	var p: Dictionary = PERSONAGENS.get(id, {"nome": id, "retrato": ""})
	return {"title": p["nome"], "dialog": texto, "faceset": p["retrato"]}

func conversa(linhas: Array) -> void:
	var falas: Array = []
	for linha in linhas:
		if linha is Array and linha.size() >= 2:
			falas.append(fala(str(linha[0]), str(linha[1])))
		else:
			push_warning("Linha inválida; esperado [personagem, texto].")
	iniciar(falas)

func aviso(texto: String) -> void:
	iniciar([{"title": "", "dialog": texto, "faceset": ""}])

func montar(id_conversa: String) -> Array:
	if not CONVERSAS.has(id_conversa):
		push_warning("Conversa não cadastrada: " + id_conversa)
		return []
	var falas: Array = []
	for item in CONVERSAS[id_conversa]:
		if item is Dictionary:
			if falas.is_empty():
				push_warning("Efeito/opções antes da primeira fala em: " + id_conversa)
			else:
				for chave in item:
					falas[falas.size() - 1][chave] = item[chave]
		elif item is Array and item.size() >= 2:
			falas.append(fala(str(item[0]), str(item[1])))
		else:
			push_warning("Entrada inválida na conversa: " + id_conversa)
	return falas

func iniciar(falas: Array) -> void:
	if ativo or falas.is_empty():
		return
	ativo = true
	var d: dialogScrim = CENA.instantiate()
	d.data = falas
	d.dialogo_terminado.connect(_ao_terminar)
	add_child(d)

func _ao_terminar() -> void:
	await get_tree().process_frame
	ativo = false

	if not _cena_apos.is_empty():
		var destino: Dictionary = _cena_apos
		_cena_apos = {}
		var cena := str(destino["cena"])
		if not ResourceLoader.exists(cena):
			push_error("Teleporte: a cena '%s' não existe. Confira o caminho." % cena)
			return
		Estado.spawn = str(destino.get("spawn", ""))
		print("[Teleporte] indo para ", cena, " (spawn '", Estado.spawn, "')")
		var erro := get_tree().change_scene_to_file(cena)
		if erro != OK:
			push_error("Teleporte: não consegui abrir '%s' (%s)" % [cena, error_string(erro)])
		return

	_verificar_grupos()

func _verificar_grupos() -> void:
	for nome in GRUPOS:
		var marca := "grupo_" + str(nome)
		if Estado.tem(marca):
			continue
		var g: Dictionary = GRUPOS[nome]
		var faltando: Array = []
		for f in g["flags"]:
			if not Estado.tem(str(f)):
				faltando.append(f)
		if not faltando.is_empty():
			if faltando.size() < g["flags"].size():
				print("[Grupo ", nome, "] faltam: ", faltando)
			continue
		Estado.marcar(marca)
		if g.has("cena"):
			_cena_apos = {"cena": g["cena"], "spawn": g.get("spawn", "")}
		falar(str(g["conversa"]))
		if not ativo:
			_cena_apos = {}
		return
