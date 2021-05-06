public class WorkingArea : Gtk.GLArea {

    construct {
        print ("init working area...\n");
        
        this.realize.connect (() => {
            print ("init gl context...\n");
        });
        
        this.render.connect (() => {
            //glClearColor (250, 250, 250, 0);
            //glClear (GL_COLOR_BUFFER_BIT);
        });
    }
}
