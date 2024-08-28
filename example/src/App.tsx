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
        openCamera(10, "fr").then((value: string) => {
          console.log({ value })
          setResult(value)
        })
      }}></Button>

      <Button title='edit Photo' onPress={() => {
        let paths = 'https://media.istockphoto.com/id/119464331/photo/tree-and-root.jpg?s=612x612&w=0&k=20&c=CWFVl9h8qUhgLDcq-bACzrP8RxtMh1D71OudJl_z99Q=,https://media.istockphoto.com/id/119464331/photo/tree-and-root.jpg?s=612x612&w=0&k=20&c=CWFVl9h8qUhgLDcq-bACzrP8RxtMh1D71OudJl_z99Q='
        let local='/data/user/0/com.mazadatimagepickerexample/cache/b92e82ac-404f-43a1-92e9-5f9f82275609.jpg'
        let local2='/data/user/0/com.mazadatimagepickerexample/cache/aa1449a9-2f60-42ac-8485-ade674aba9f1.jpg'
        
        let localIos = '/Users/Karim.Saad/Library/Developer/CoreSimulator/Devices/02997294-C79E-4388-B2F3-FA76BF9E9011/data/Containers/Data/Application/5FD3F6DB-6F8D-4E5C-A291-B0B87791586C/Documents/9550A9D6-652C-44A3-8FA3-771B85E9D125.jpg,/Users/Karim.Saad/Library/Developer/CoreSimulator/Devices/02997294-C79E-4388-B2F3-FA76BF9E9011/data/Containers/Data/Application/5FD3F6DB-6F8D-4E5C-A291-B0B87791586C/Documents/80B9CCDC-D2E1-44A6-B1F6-4028DDAFADAD.jpg,/Users/Karim.Saad/Library/Developer/CoreSimulator/Devices/02997294-C79E-4388-B2F3-FA76BF9E9011/data/Containers/Data/Application/5FD3F6DB-6F8D-4E5C-A291-B0B87791586C/Documents/AC04E454-8C6F-4897-8409-550159CD4CDE.jpg'
        editPhoto(local, 0, "en").then((value: string) => {
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
