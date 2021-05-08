using GL;
using GLEW;

public class WorkingAreaGL : Gtk.GLArea {

    private const float track_height = 40.0f;
    
    private Gtk.Allocation current_allocation;

    construct {
        print ("init working area...\n");
        
        Gtk.Allocation allocation;
        this.get_allocation (out allocation);
        
        this.realize.connect (() => {
            print ("init gl context...\n");
    
            make_current ();
            
            int major;
            int minor;
            var context = get_context ();
            context.get_version (out major, out minor);
            
            print ("gl version: %d.%d\n", major, minor);
            if (get_use_es ()) {
                print ("using opengl es\n");
            }
            
            if (glewInit () != 0) {
                print ("cannot initialize glew\n");
            }
            
            float positions[6] = {
               -0.5f, -0.5f,
                0.0f,  0.5f,
                0.5f, -0.5f
            };
            
            uint[] buffers = new uint[1];
            glGenBuffers (1, buffers);
            glBindBuffer (GL_ARRAY_BUFFER, buffers[0]);
            glBufferData (GL_ARRAY_BUFFER, 6 * sizeof (float), (GLvoid[]) positions, GL_STATIC_DRAW);
        });
        

        this.render.connect (() => {
            //glClearColor (0.93f, 0.93f, 0.93f, 1.0f);
            glClear (GL_COLOR_BUFFER_BIT);
            
            glBegin (GL_TRIANGLES);
            glVertex2f (-0.5f, -0.5f);
            glVertex2f (0, 0.5f);
            glVertex2f (0.5f, -0.5f);
            glEnd ();
            
            //draw_tracks ();
            
            return true;
        });
    }
    
    private void draw_tracks () {
        // 
        // for (float track_y = 0;
        //      track_y + track_height < current_allocation.height;
        //      track_y += track_height) {
        //      
        //     glBegin (GL_LINES);
        //         glVertex2f (0, 500);
        //     glEnd ();
        // }
        // 
        glBegin(GL_TRIANGLES);
            glColor3f (0, 0, 0);
            glVertex3f( 0.0f, 1.0f, 0.0f);				// Top
            glVertex3f(-1.0f,-1.0f, 0.0f);				// Bottom Left
            glVertex3f( 1.0f,-1.0f, 0.0f);				// Bottom Right
	    glEnd();							// Finished Drawing The Triangle
        
        var error = get_error ();
        if (error != null) {
            print ("error: %s", error.message);
        }
    }
}
