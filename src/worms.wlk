import wollok.game.*

object juego {
	
	method iniciar(){
		game.cellSize(20)
		game.height(20)
		game.width(35)
		self.personajes()		
		game.start()
	}
	method personajes() {
		game.addVisual(mario)
		game.addVisual(luiggi)
		keyboard.space().onPressDo{mario.disparar(true)}
		keyboard.enter().onPressDo{mario.disparar(false)}
		
	}
	
	
}




object mario {
	var puntaje = 0
	method image() = "mario.png"
	method position() = game.at(2,2)
	
	method text() = puntaje.toString()
	
	method disparar(distraido){
		var proyectil
		if (distraido) 
			proyectil = new Bola(position=self.position().right(1))
		else
			proyectil = new Bazooka(position=self.position().right(1))
		proyectil.hacerRecorrido()
		game.schedule(1000,{self.dispararBalaPlata()})
	}
	method dispararBalaPlata(){
		if(game.hasVisual(balaDePlata)){
			game.removeVisual(balaDePlata)
			balaDePlata.volverAlInicio()
		}
		balaDePlata.hacerRecorrido()
		
		
	}
	method sumaPuntos(cantidad) {
		puntaje += cantidad
	}
}


object luiggi {
	method image() = "luiggi.png"
	method position() = game.at(25,2)
	
	method serImpactado(){
		game.removeVisual(self)
	}
}

class Proyectil {
	var property position
	var puntos 

	method image()
	
	method hacerRecorrido() {
		game.addVisual(self)
		game.onCollideDo(self,{algo=>
			algo.serImpactado()
			self.detener()
		})
		game.onTick(500,self.idTick(),{self.desplazarse()})
			
	}
	method desplazarse()
	method idTick()
	method detener(){
		game.removeTickEvent(self.idTick())
		game.removeVisual(self)
		mario.sumaPuntos(puntos)
	}
	
	method serImpactado(){}
	
}

class Bazooka inherits Proyectil(puntos=7){
	method image() = "bazooka.png"
	override method desplazarse(){
		position = position.right(2)
	}
	method idTick() = "desplBazzoka"
}

class Bola inherits Proyectil(puntos=10){
	method image() = "azul.png"
	override method desplazarse(){
		position = position.right([1,2,3].anyOne())
	}
	method idTick() = "despBola"
	
	override method detener(){
		game.say(mario,"explosion!!")
		super()
	}
}

object balaDePlata inherits Proyectil(puntos = 100, position = mario.position().up(1)){
	override method image() = "churrasco.png"
	
	override method desplazarse(){
		position = position.up(1).right(3)
	}
	method volverAlInicio() {
		game.removeTickEvent(self.idTick())
		position = mario.position().up(1) 
	}
	method idTick() = "despPlata"
	
}

