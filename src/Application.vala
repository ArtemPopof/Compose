/*
* Copyright (c) 2021 ArtemPopov
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Artem Popov <artempopovserg@gmail.com>
*/
public class Application : Gtk.Application {

    private Controller controller;
    private WorkingArea working_area;

    Application () {
        Object (
            application_id: "com.github.abbysoft-team.compose",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }
    
    ~Application () {

    }

  
    protected override void activate () {
        // initialize backend
        var backend = new JackAudioInterfaceImpl ();
        if (backend.init () != 0) {
            stderr.printf ("failed to initialize backend\n");
            Process.exit (1);
        }
        
        working_area = new WorkingArea ();
        
        controller = new Controller (backend, working_area);
        controller.init ();
        
        
        var main_window = create_main_window ();
       
        var content_container = new Gtk.Grid () {
            orientation = Gtk.Orientation.HORIZONTAL   
        };
        
        content_container.add (create_controls_panel ());
        content_container.add (create_working_area());
        
        main_window.add (content_container);
        
        main_window.show_all ();
    }
    
    private Gtk.Window create_main_window () {
        var main_window = new Gtk.ApplicationWindow (this);
        main_window.title = _("Compose");

        main_window.default_width = 1111;
        main_window.default_height = 777;

        
        //Granite.Widgets.Utils.set_color_primary (main_window, {222, 22, 0, 256});
        
        return main_window;
    }
    
    private Gtk.Grid create_controls_panel () {
        var container = new Gtk.Grid () {
            orientation = Gtk.Orientation.VERTICAL
        };
        
        container.add (create_track_controls ());
        container.add (create_track_controls ());
        container.add (create_track_controls ());
        
        return container;
    }
    
    private Gtk.Box create_track_controls () {
        var container = new Gtk.Box (HORIZONTAL, 5);
        
        container.add (create_record_button ());
        container.add (new Gtk.Button.with_label (_("Play")));
        container.add (create_stop_button ());

        container.vexpand = true;
        
        return container;
    }
    
    private Gtk.Button create_record_button () {
        Gtk.Button button = new Gtk.Button.with_label (_("Record"));
        button.clicked.connect (() => {
            controller.record ();
        });
        
        return button;
    }
    
    private Gtk.Button create_stop_button () {
        Gtk.Button button = new Gtk.Button.with_label (_("Stop"));
        button.clicked.connect (() => {
            controller.stop ();
        });
        
        return button;
    }
    
    private Gtk.Box create_working_area () {
        var container = new Gtk.Box (VERTICAL, 5);
        
        working_area.hexpand = true;
        working_area.vexpand = true;
        
        container.add (working_area);
        
        container.vexpand = true;
        container.hexpand = true;
                
        return container;
    }
    
    private Gtk.Box create_track_body () {
        var container = new Gtk.Box (VERTICAL, 5);
        
        var label = new Gtk.Label (_("start recording"));
        label.justify = Gtk.Justification.CENTER;
        label.get_style_context ().add_class (Granite.STYLE_CLASS_H1_LABEL);
        
        container.valign = Gtk.Align.CENTER;

        container.add (label);
        
        container.hexpand = true;
        container.vexpand = true;

        return container;
    }
    
    public static int main (string[] args) {
        if (!Thread.supported ()) {
            stderr.printf ("Cannot run without thread support.\n");
            return 1;
        }
        
        var app = new Application ();
        
        return app.run (args);
    }

}
