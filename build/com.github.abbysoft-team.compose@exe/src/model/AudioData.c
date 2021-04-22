/* AudioData.c generated by valac 0.40.25, the Vala compiler
 * generated from AudioData.vala, do not modify */



#include <glib.h>
#include <glib-object.h>


#define TYPE_AUDIO_DATA (audio_data_get_type ())
#define AUDIO_DATA(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_AUDIO_DATA, AudioData))
#define AUDIO_DATA_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TYPE_AUDIO_DATA, AudioDataClass))
#define IS_AUDIO_DATA(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_AUDIO_DATA))
#define IS_AUDIO_DATA_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TYPE_AUDIO_DATA))
#define AUDIO_DATA_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TYPE_AUDIO_DATA, AudioDataClass))

typedef struct _AudioData AudioData;
typedef struct _AudioDataClass AudioDataClass;
typedef struct _AudioDataPrivate AudioDataPrivate;
enum  {
	AUDIO_DATA_0_PROPERTY,
	AUDIO_DATA_NUM_PROPERTIES
};
static GParamSpec* audio_data_properties[AUDIO_DATA_NUM_PROPERTIES];

struct _AudioData {
	GObject parent_instance;
	AudioDataPrivate * priv;
};

struct _AudioDataClass {
	GObjectClass parent_class;
};


static gpointer audio_data_parent_class = NULL;

GType audio_data_get_type (void) G_GNUC_CONST;
AudioData* audio_data_new (void);
AudioData* audio_data_construct (GType object_type);


AudioData*
audio_data_construct (GType object_type)
{
	AudioData * self = NULL;
#line 1 "/home/artem/Documents/ElementaryProjects/Compose/src/model/AudioData.vala"
	self = (AudioData*) g_object_new (object_type, NULL);
#line 1 "/home/artem/Documents/ElementaryProjects/Compose/src/model/AudioData.vala"
	return self;
#line 52 "AudioData.c"
}


AudioData*
audio_data_new (void)
{
#line 1 "/home/artem/Documents/ElementaryProjects/Compose/src/model/AudioData.vala"
	return audio_data_construct (TYPE_AUDIO_DATA);
#line 61 "AudioData.c"
}


static void
audio_data_class_init (AudioDataClass * klass)
{
#line 1 "/home/artem/Documents/ElementaryProjects/Compose/src/model/AudioData.vala"
	audio_data_parent_class = g_type_class_peek_parent (klass);
#line 70 "AudioData.c"
}


static void
audio_data_instance_init (AudioData * self)
{
}


GType
audio_data_get_type (void)
{
	static volatile gsize audio_data_type_id__volatile = 0;
	if (g_once_init_enter (&audio_data_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (AudioDataClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) audio_data_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (AudioData), 0, (GInstanceInitFunc) audio_data_instance_init, NULL };
		GType audio_data_type_id;
		audio_data_type_id = g_type_register_static (G_TYPE_OBJECT, "AudioData", &g_define_type_info, 0);
		g_once_init_leave (&audio_data_type_id__volatile, audio_data_type_id);
	}
	return audio_data_type_id__volatile;
}


