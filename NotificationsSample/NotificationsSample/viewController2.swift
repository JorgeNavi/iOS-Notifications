import UIKit

//Lo ideal cuando creamos notificaciones es crear una extensión de Notification.Name para crear una constante con el nombre de la notificación, de tal manera que nos evitamos el uso de Strings y nos protegemos ante errores
extension Notification.Name {
    static let colorChanged = Notification.Name("colorChanged")
}

class viewController2: UIViewController {
    
    
    //Estamos añadiendo la contraint con respecto al borde de abajo del boton de aceptar
    @IBOutlet weak var constraintButton: NSLayoutConstraint!
    private let defaultHeight: CGFloat = 78 //aqui le establecemos el valor predeterminado a esa constraint(78 porque son los puntos que se habian establecido al poner la constraint en el stroyboard
    
    
    
    
    //igual que hacemos con la extension de Notification.name, vamos a crear una constante para las claves del diccionario de colors (pasando de "currentColor":color(como elemento random) a Self.currentColorKey:color
    static let currentColorKey = "currentColor"
    
    //vamos a establecer un array de colores. Jugando con las notificaciones vamos a cambiar el color de background de la segunda pantalla mediante un botón y, al mismo tiempo, cambiará el color de la primera por el mismo color. La elección del color será aleatoria
    var colors: [UIColor] = [.red, .blue, .green, .yellow, .purple, .orange]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Observamos los cambios de frame del teclado
        //el observador es self, el selector o codigo que se va a ejecutar al recibir esa notificacion, es el metodo de cambiar el frame del teclado. El nombre nos lo da el propio compilador que hace referencia a eso mismo (el frame del teclado) y el objeto nil (casi siempre va a ser nil).
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameDidChanged), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //eliminamos el observer
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
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
    
    
    @IBAction func aceptarTapped(_ sender: Any) {
        // Esto oculta el teclado cuando se pulsa el botón "Aceptar"
        view.endEditing(true)
    }
    
    @objc func keyboardFrameDidChanged(notification: Notification) {
        // Verifica si es posible obtener la información del teclado de la notificación recibida
        guard let userInfo = notification.userInfo else { return }
        // Imprime la información del teclado para depuración
        debugPrint(userInfo)
        
        // Calculamos la altura del boton con la informacion que recibimos en la notificacion en userInfo
        if let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            // Obtiene la duración de la animación del teclado, o utiliza 0.25 segundos como valor por defecto
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
            // Anima los cambios de la interfaz para ajustarse al nuevo tamaño de la pantalla visible cuando aparece el teclado, aniuma un cambio de constraint
            UIView.animate(withDuration: duration) {
                // Ajusta la restricción del botón para moverlo arriba junto con el teclado
                self.constraintButton.constant = self.defaultHeight + (UIScreen.main.bounds.height - frame.origin.y)
                // Actualiza la disposición de las vistas para reflejar el cambio de la restricción
                self.view.layoutIfNeeded()
            }
        }
    }
}
