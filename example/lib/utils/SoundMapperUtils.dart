
import 'package:voice_example/viewobject/model/sound/Sound.dart';
import 'package:voice_example/viewobject/model/sound/Sounds.dart';

class SoundMapperUtils
{
  static getSelectedSound(String selectedSound)
  {
    Sound selected;
    List<Sound> elements = soundsList.map((json) => Sound().fromJson(json)).toList();
    if(selectedSound==null)
    {
      return elements[0];
    }

    elements.forEach((element)
    {
      if(selectedSound.toLowerCase().contains(element.assetUrl.toLowerCase()))
      {
        selected = element;
      }
    });
    return selected;
  }

  static getSoundsList()
  {
    return soundsList.map((json) => Sound().fromJson(json)).toList();
  }
}
