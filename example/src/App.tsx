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
        let local='/data/user/0/com.mazadatimagepickerexample/cache/60dde919-0e39-4452-b9dc-9c00b4243225.jpg,/data/user/0/com.mazadatimagepickerexample/cache/49193003-3cf6-43d5-9b0f-f843de7356b0.jpg,/data/user/0/com.mazadatimagepickerexample/cache/68b72316-fdf7-42d4-afcb-8403911572b6.jpg'
        let local2='/data/user/0/com.mazadatimagepickerexample/cache/f67fe8c5-ec75-41b5-8d48-05ba50be8758.jpg'
        
        let localIos = '/Users/Karim.Saad/Library/Developer/CoreSimulator/Devices/02997294-C79E-4388-B2F3-FA76BF9E9011/data/Containers/Data/Application/5FD3F6DB-6F8D-4E5C-A291-B0B87791586C/Documents/9550A9D6-652C-44A3-8FA3-771B85E9D125.jpg,/Users/Karim.Saad/Library/Developer/CoreSimulator/Devices/02997294-C79E-4388-B2F3-FA76BF9E9011/data/Containers/Data/Application/5FD3F6DB-6F8D-4E5C-A291-B0B87791586C/Documents/80B9CCDC-D2E1-44A6-B1F6-4028DDAFADAD.jpg,/Users/Karim.Saad/Library/Developer/CoreSimulator/Devices/02997294-C79E-4388-B2F3-FA76BF9E9011/data/Containers/Data/Application/5FD3F6DB-6F8D-4E5C-A291-B0B87791586C/Documents/AC04E454-8C6F-4897-8409-550159CD4CDE.jpg'
        editPhoto(local2, 0, "en").then((value: string) => {
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
