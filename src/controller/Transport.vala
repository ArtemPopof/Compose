public interface Transport : GLib.Object {
    public abstract void move_transport (ulong frames);
    public abstract void samples_preview (ulong frames, double average_level);
}
