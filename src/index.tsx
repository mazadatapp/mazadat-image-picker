import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'mazadat-image-picker' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const MazadatImagePicker = NativeModules.MazadatImagePicker
  ? NativeModules.MazadatImagePicker
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function openCamera(length: number,lang: String): Promise<number> {
  return MazadatImagePicker.openCamera(length, lang);
}

export function editPhoto(path: String,index: number,lang: String): Promise<number> {
  return MazadatImagePicker.editPhoto(path,index, lang);
}

export function openIdVerification(lang: String): Promise<number> {
  return MazadatImagePicker.openIdVerification(lang);
}
