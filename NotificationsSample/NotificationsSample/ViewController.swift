
import UIKit

class ViewController: UIViewController {
    
    //Este es el método que se ejecuta al final del ciclo de vida del controller
    deinit {
        if let observer {
            NotificationCenter.default.removeObserver(observer) //Con esto se elimina el observer de la memoria. Se cierra en el deinit() porque es el mejor sitio para hacerlo si creamos la notificacion en el viewDidLoad(). Si se creara en el viewWillAppear por ejemplo, se eliminaría en el viewWillDisappear()
        }
    }
    
    var observer: NSObjectProtocol? //variable para guardar nuestro observer

    override func viewDidLoad() {
        super.viewDidLoad()
        //Vamos a crear las notificaciones:
        //Vamos a imprimir también el valor (que es un String) de UIApplication.willEnterForegroundNotification para entender mejor qué es lo que hace:
        print(UIApplication.willEnterForegroundNotification.rawValue) //rawValue nos va a dar su valor
        
        //hemos movido las notificaciones a la funcion addObservers para que no quede muy sucio
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Si añado aqui un observer he de quitarlo en el viewWillDisappear. Por que? porque si retornamos a esta pantalla desde viewController2, al aparecer genera otro observer con este metodo y si segumis interactuando entre pantallas se irán acumulando estos observers. El hecho de que ya exista un observer ¡¡NO SIGNIFICA QUE NO SE CREEN MÁS!!
        
        //El observador self, ejecuta el selector(colorDidChanged) al recibir una notificacion de nombre .colorChanged (de la extension en viewController 2) desde cualquier objeto
        //NotificationCenter.default.addObserver(self, selector: #selector(colorDidChange), name: .colorChanged, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //eliminamos el observer
        //NotificationCenter.default.removeObserver(self, name: .colorChanged, object: nil)
        //Sin embargo, al eliminar el observer, si volvemos a esta pabtalla desde viewController2 y se elimina el observer, no se va a mantener el cambio de color porque ya no hay ningun observador escuchando a la notificación. Por ello lo suyo es que esta notificación se configure en el viewDidLoad()
    }
    
    func addObservers () {
        /* Vamos a desglosarlo paso a paso:
        
        1.    NotificationCenter.default:
        •    Aquí estás accediendo al centro de notificaciones predeterminado del sistema (default). Es el que se usa para escuchar y enviar notificaciones dentro de tu aplicación.
        2.    addObserver(self, selector: #selector(appWillRenterInBackground), name: UIApplication.didEnterBackgroundNotification, object: nil):
        •    Con el método addObserver(), estás diciendo al NotificationCenter que quieres que un objeto (en este caso, self, es decir, la propia clase o vista) observe o escuche una notificación específica.
        •    Parámetros:
        •    self: Este es el objeto que actuará como observador. Normalmente, es la propia clase o vista (como una UIViewController).
        •    selector: #selector(appWillRenterInBackground): Aquí estás indicando qué método o función debe llamarse cuando ocurra la notificación. El selector utiliza #selector para referenciar el método que será ejecutado. En este caso, estás diciendo que quieres ejecutar el método appWillRenterInBackground cuando se reciba la notificación.
        •    name: UIApplication.didEnterBackgroundNotification: Esta es la notificación específica que estás observando. En este caso, es UIApplication.didEnterBackgroundNotification, que es enviada cuando la aplicación entra en segundo plano (es decir, ya no está activa en primer plano, como cuando el usuario presiona el botón de inicio o cambia a otra aplicación).
        •    object: nil: Este parámetro indica qué objeto específico estás observando para esta notificación. Si lo dejas como nil, significa que recibirás la notificación sin importar qué objeto la envíe. */

        
        //de esta ,anera las notificaciones se envían en el hilo en el que se encuentra el sender.
        //Si queremos asegurarnos de ejecutar el código tras recibir la notificación en un hilo concreto es responsabilidad nuestra, es decir, habria que especificar el hilo donde queremos que se ejecute (poniendo en este caso el DispatchQueue en el método appWillRenterInBackground que es lo que nuestro selector indica que metodo o funciono debe ser llamado cuando ocurra la notificación
        //esta forma de hacerlo, desde iOS 11, el sistema se encarga de destruir los observers de manera automática cuando se destruya el controller (cuando deje de funcionar)
       NotificationCenter.default.addObserver(self, selector: #selector(appWillRenterInBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        
        /* NotificationCenter.default.addObserver(forName:object:queue:using:):
         •    Este método también está registrando un observador para una notificación específica, pero en lugar de utilizar un selector (como en el primer ejemplo), está utilizando un closure o bloque de código que se ejecutará cuando ocurra la notificación.
         •    Parámetros:
         •    forName: UIApplication.willEnterForegroundNotification: Aquí se especifica el nombre de la notificación que estás observando. En este caso, es UIApplication.willEnterForegroundNotification, que es enviada cuando la aplicación vuelve al primer plano (por ejemplo, cuando el usuario vuelve a la app desde la pantalla de inicio o desde otra aplicación).
         •    object: self: Especifica el objeto emisor de la notificación. Al establecer self, estás diciendo que solo quieres recibir la notificación si fue enviada por el objeto self. Si pones nil, recibirás todas las notificaciones de ese tipo sin importar qué objeto las envía.
         •    queue: .main: Indica la cola donde quieres que se ejecute el closure. Aquí estás diciendo que quieres que se ejecute en la cola principal (.main), que es donde ocurren todas las actualizaciones de la interfaz de usuario. Si no especificas la cola, se puede ejecutar en un hilo de fondo, lo que puede ser útil para tareas que no afecten directamente la interfaz.
         •    using: { notification in ... }: Este es el closure que se ejecutará cuando ocurra la notificación. En el cuerpo del closure, tienes acceso a la notificación recibida a través del parámetro notification.
         2.    print(notification): En este caso, simplemente estás imprimiendo la notificación recibida, pero dentro de este closure podrías hacer cualquier cosa, como actualizar la interfaz o realizar algún cálculo.
         */
        
        //Si no especificamos el objeto, recibiremos cualquier notificacion que tenga el nombre dado (en este caso UIApplication.willEnterForegroundNotification), si ponemos algun objeto, indicara que solo recibiremos notificaciones que se lleamen asi y de ese objeto
        //esta forma de hacerlo devulve un objeto que es un protocolo que no se va a eliminar por si solo cuando se destruya el controller, hay que tener cuidado al usarlo. Habria que destruirlo en el metodo deinit() del controller.
            observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { notification in //Nos guardamos una referenica al observer con esa variable observer para poder deinicializarla en el metodo deinit().
            print(notification) //forName indica el nombre de la notificación a la que nos estamos suscribiendo
        }
        NotificationCenter.default.addObserver(self, selector: #selector(colorDidChange), name: .colorChanged, object: nil)
        
        
        /* Diferencias principales entre los dos enfoques:
         
         1.    Uso de selector vs closure:
         •    En el primer código, se utiliza un selector (#selector(appWillRenterInBackground)), que hace referencia a un método que debe ser implementado en la clase. Este método se ejecutará cuando se reciba la notificación.
         •    En el segundo código, se utiliza un closure, que es un bloque de código que se ejecuta directamente en el lugar donde registraste la notificación, sin la necesidad de definir un método aparte.
         2.    Notificaciones diferentes:
         •    El primer ejemplo escucha la notificación UIApplication.didEnterBackgroundNotification, que ocurre cuando la app entra en segundo plano.
         •    El segundo ejemplo escucha UIApplication.willEnterForegroundNotification, que ocurre cuando la app está a punto de volver al primer plano.
         3.    Flexibilidad del closure:
         •    Usar un closure es más conveniente cuando quieres registrar una notificación rápidamente y ejecutar un pequeño bloque de código, sin la necesidad de crear un método completo como con el selector.
         •    Sin embargo, los closures también pueden hacer que el código sea más difícil de seguir cuando crecen en tamaño o se complejizan. Usar un selector es más claro en algunos casos, especialmente cuando el comportamiento relacionado con la notificación es más extenso.
         4.    Cola de ejecución:
         •    En el segundo código, puedes especificar en qué cola quieres que se ejecute el closure (en este caso, en la cola principal: .main). Esto te da más control sobre el lugar donde se ejecuta la lógica. En el primer código, este control no se especifica directamente.

     ¿Cuándo usar cada uno?

         •    Selectors son útiles cuando ya tienes un método bien definido y prefieres mantener el código más modular. Si esperas que la notificación active un comportamiento complejo, un selector te permite mantener las responsabilidades separadas.
         •    Closures son más útiles cuando necesitas registrar una notificación de forma rápida o cuando la lógica es pequeña y no necesitas un método separado para manejarla. Es conveniente para casos simples y rápidos, pero puede volverse desordenado si la lógica dentro del closure crece.

     Ambos son válidos, y la elección depende del contexto y la complejidad de lo que quieres hacer cuando la notificación se dispara.*/
    }
    
    
    @objc func appWillRenterInBackground() { //Esta es la funcion que se pasa en el primer caso
        //Nos aseguramos de que el código se ejecuta en el hilo principal
        DispatchQueue.main.async {
            print("App will enter background")
        }
        
    }
    // Creamos el selector que vamos a pasar a la notificacion del cambio de color (el codigo que se va a ejecutar al recibir la notificacion
    @objc func colorDidChange(_ notification: Notification) {
        
        //Comprobamos el valor opcional del diccionario de userInfo
        guard let userInfo = notification.userInfo else { return }//Si viene vacío, return
        //con viewController2.currentColorKey, accedemos a la prpiedad statica de la clave del diccionario dada en viewController2 (accedemos a static let currentColorKey = "currentColor")
        if let color = userInfo[viewController2.currentColorKey] as? UIColor { //Si la constante color que establecemos aqui tiene el valor del diccionario de colores como un UIColor, el color del background de la vista = a ese color
            view.backgroundColor = color
        }
    }


}

