import UIKit

//Lo ideal cuando creamos notificaciones es crear una extensión de Notification.Name para crear una constante con el nombre de la notificación, de tal manera que nos evitamos el uso de Strings y nos protegemos ante errores
extension Notification.Name {
    static let colorChanged = Notification.Name("colorChanged")
}

class viewController2: UIViewController {
    
    //igual que hacemos con la extension de Notification.name, vamos a crear una constante para las claves del diccionario de colors (pasando de "currentColor":color(como elemento random) a Self.currentColorKey:color
    static let currentColorKey = "currentColor"
    
    //vamos a establecer un array de colores. Jugando con las notificaciones vamos a cambiar el color de background de la segunda pantalla mediante un botón y, al mismo tiempo, cambiará el color de la primera por el mismo color. La elección del color será aleatoria
    var colors: [UIColor] = [.red, .blue, .green, .yellow, .purple, .orange]

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //unimos desde la interfaz el boton de cambiar color aquí para establecer la funcionalidad del botón
    @IBAction func changeColorTapped(_ sender: Any) {
        let color = colors.randomElement() ?? .clear //Si no conseguimos color, clear. Esta funcion de random devuelve un opcional y por eso lo aseguramos aqui
        self.view.backgroundColor = color //el background del controlador es igual a la lista de colores ejecutando el método randomElement() para seleccionar elementos de manera aleatoria
        //Una vez que hemos cabiado el color, vamos a crear nuestra primera notificación para que el color de la primera pantalla cambie a la vez que el de la segunda
        //Nombre de la notificacion: "colorChanged". Objeto que va a recibir la notificacion: self. La información añadida es un diccionario de clave Self.currentColorKey con el valor que devuelva la funcion random
        NotificationCenter.default.post(name: .colorChanged, object: self, userInfo: [Self.currentColorKey: color])
            /* el self del currentColorKey esta en mayúscula se debe a que estamos accediendo a una propiedad estatica de una clase dentro de su propia clase. Si accedieramos desde fuera usariamos el nombre de la clase. Por que? si escribimos:
            self.currentColorKey estamos intentando acceder a currentColorKey de una instancia concreta de la clase
            Self.currentColorKey en cambio así con mayúscula estamos accediendo a la propiedad de la clase, no de una instancia de la clase */
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
