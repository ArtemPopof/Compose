public interface Transport : GLib.Object {
    public abstract void move_transport (ulong frames);
    public abstract void samples_preview (int real_samples_mult, float[] preview_samples);
}
