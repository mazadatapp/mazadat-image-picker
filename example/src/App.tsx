import * as React from 'react';

import { StyleSheet, View, Text, Button } from 'react-native';
import { openCamera, editPhoto, openIdVerification } from 'mazadat-image-picker';

export default function App() {
  const [result, setResult] = React.useState<string | undefined>();

  const androidPath = 'https://www.aussietreesolutions.com.au/wp-content/uploads/2018/08/facts-about-trees-1037x675.jpg'
  const iosPath = 'https://www.aussietreesolutions.com.au/wp-content/uploads/2018/08/facts-about-trees-1037x675.jpg'
  return (
    <View style={styles.container}>
      <Button title='open Camera' onPress={() => {
        openCamera(10, "en").then((value: string) => {
          console.log({ value })
          setResult(value)
        })
      }}></Button>

      <Button title='edit Photo' onPress={() => {
        let paths = 'https://img.freepik.com/premium-photo/mountains-during-flowers-blossom-sunrise-flowers-mountain-hills-beautiful-natural-landscape-summer-time-mountainimage_647656-1502.jpg,https://images.ctfassets.net/hrltx12pl8hq/6bi6wKIM5DDM5U1PtGVFcP/1c7fce6de33bb6575548a646ff9b03aa/nature-photography-pictures.jpg?fit=fill&w=600&h=400,https://c8.alamy.com/comp/R6F16B/beautiful-natural-picture-R6F16B.jpg'
        let local='/data/user/0/com.mazadatimagepickerexample/cache/140db6d7-a462-46bf-9f8e-829652fd2d0e.jpg,/data/user/0/com.mazadatimagepickerexample/cache/18d22325-2acd-4811-841e-a3cb6443e95f.jpg,/data/user/0/com.mazadatimagepickerexample/cache/f966a485-3b1c-47b1-a2ba-b229af24e83a.jpg'
        editPhoto(local, 2, "en").then((value: string) => {
          console.log({ value })
          setResult(value)
        })
      }}></Button>

      <Button title='ID verification' onPress={() => {
        openIdVerification("ar").then((value: string) => {
          console.log({ value })
          setResult(value)
        })
      }}></Button>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
