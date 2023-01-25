import * as React from 'react';

import { StyleSheet, View, Text, Button } from 'react-native';
import { multiply,openCamera,editPhoto } from 'mazadat-image-picker';

export default function App() {
  const [result, setResult] = React.useState<string | undefined>();

  ///data/user/0/com.mazadatimagepickerexample/cache/1674639725834.jpg

  return (
    <View style={styles.container}>
      <Button title='open' onPress={()=>{ openCamera(10,"en").then((value: string) => {
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
