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
    private AudioContext context;
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
        var context = new AudioContext ();
        var backend = context.get_audio_interface ();
        if (backend.init () != 0) {
            stderr.printf ("failed to initialize backend\n");
            Process.exit (1);
        }
        
        controller = new Controller (backend);
        controller.init ();
        
        working_area = new WorkingArea (controller);
        
        controller.working_area = working_area;
        
        var main_window = create_main_window ();
       
        var content_container = new Gtk.Grid () {
            orientation = Gtk.Orientation.HORIZONTAL   
        };
        
        
        content_container.add (create_controls_panel (working_area.tracks));
        content_container.add (create_working_area());
        
        main_window.add (content_container);
        
        main_window.show_all ();
    }
    
    private Gtk.ApplicationWindow create_main_window () {
        var main_window = new Gtk.ApplicationWindow (this);
        main_window.title = _("Compose");

        main_window.default_width = 1111;
        main_window.default_height = 777;
        
        main_window.set_titlebar (create_title_bar ());

        
        //Granite.Widgets.Utils.set_color_primary (main_window, {0.8, 0.8, 0.8, 1});
        
        return main_window;
    }
    
    private Gtk.HeaderBar create_title_bar () {
        var header_bar = new Gtk.HeaderBar ();
        
        header_bar.set_show_close_button (true);
        header_bar.title = _("Untitled");
        header_bar.has_subtitle = false;
        
        var transport_controls = new TransportWidget (controller);
        
        header_bar.pack_start (new Gtk.Button.with_label (_("New")));
        header_bar.pack_start (new Gtk.Button.with_label (_("Open")));
        header_bar.pack_start (new Gtk.Button.with_label (_("Save")));
        header_bar.pack_start (new Gtk.Label (_("                              ")));
        header_bar.pack_start (transport_controls);
        
        return header_bar;
    }
    
    private Track[] create_tracks (int count) {
        var tracks = new Track[count];
        
        return tracks;
    }
    
    private Gtk.Grid create_controls_panel (Track[] tracks) {
        var container = new Gtk.Grid () {
            orientation = Gtk.Orientation.VERTICAL
        };
        
        var visible_tracks = 3;
        
        for (int i = 0; i < visible_tracks; i++) {
            container.add (tracks[i].controls_widget);
        }
        
        return container;
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
    
    public static int main (string[] args) {
        if (!Thread.supported ()) {
            stderr.printf ("Cannot run without thread support.\n");
            return 1;
        }
        
        var app = new Application ();
        
        return app.run (args);
    }

}
