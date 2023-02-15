import * as React from 'react';

import { StyleSheet, View, Text, Button } from 'react-native';
import { openCamera,editPhoto } from 'mazadat-image-picker';

export default function App() {
  const [result, setResult] = React.useState<string | undefined>();

  const androidPath='/data/user/0/com.mazadatimagepickerexample/cache/1674639725834.jpg'
  const iosPath='/Users/Karim.Saad/Library/Developer/CoreSimulator/Devices/1E6C7C7A-6D8F-4A17-BBBF-D8FCD57D3001/data/Containers/Data/Application/FBAD79CE-CC78-4D97-B94C-B7E12079F80F/Documents/1675093435.jpg'
  return (
    <View style={styles.container}>
      <Button title='open Camera' onPress={()=>{ openCamera(3,"en").then((value: string) => {
        console.log({value})
        setResult(value)
      })}}></Button>

      <Button title='edit Photo' onPress={()=>{ editPhoto(result,"en").then((value: string) => {
              console.log({value})
              setResult(value)
            })}}></Button>
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
