# mazadat-image-picker

library to get image from camera from pick image from gallery

## Installation

```sh
npm install mazadat-image-picker
```

## Usage

```js
import { openCamera,editPhoto,openIdVerification } from 'mazadat-image-picker';

// ...

openCamera(3,"en").then((value: string) => {
        console.log({value})
        setResult(value)
      })

editPhoto(path/to/image,"en").then((value: string) => {
              console.log({value})
              setResult(value)
            })
openIdVerification("en").then((value: string) => {
              console.log({value})
              setResult(value)
            })
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MAZADAT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
