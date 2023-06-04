import * as React from 'react';

import { StyleSheet, View, Text, Button } from 'react-native';
import { openCamera,editPhoto,openIdVerification } from 'mazadat-image-picker';

export default function App() {
  const [result, setResult] = React.useState<string | undefined>();

  const androidPath='https://www.aussietreesolutions.com.au/wp-content/uploads/2018/08/facts-about-trees-1037x675.jpg'
  const iosPath='https://www.aussietreesolutions.com.au/wp-content/uploads/2018/08/facts-about-trees-1037x675.jpg'
  return (
    <View style={styles.container}>
      <Button title='open Camera' onPress={()=>{ openCamera(3,"en").then((value: string) => {
        console.log({value})
        setResult(value)
      })}}></Button>

      <Button title='edit Photo' onPress={()=>{ editPhoto(androidPath,"en").then((value: string) => {
              console.log({value})
              setResult(value)
            })}}></Button>

      <Button title='ID verification' onPress={()=>{ openIdVerification("en").then((value: string) => {
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
