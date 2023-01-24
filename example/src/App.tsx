import * as React from 'react';

import { StyleSheet, View, Text, Button } from 'react-native';
import { multiply,openCamera } from 'mazadat-image-picker';

export default function App() {
  const [result, setResult] = React.useState<number | undefined>();


  return (
    <View style={styles.container}>
      <Button title='open' onPress={()=>{ openCamera(10).then(setResult)}}></Button>
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
