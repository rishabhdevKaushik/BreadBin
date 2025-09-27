import { StyleSheet } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import Input from "../components/input";
import Numpad from "../components/numpad";
import {
  InputProvider,
  InputTypeProvider,
  TotalProvider,
} from "../utils/contexts";
import getTheme from "../utils/getTheme";

export default function home() {
  const theme = getTheme();

  const styles = createStyles(theme);
  return (
    <TotalProvider>
      <InputProvider>
        <InputTypeProvider>
          <SafeAreaView style={styles.container}>
            <Input theme={theme} />
            <Numpad theme={theme} />
          </SafeAreaView>
        </InputTypeProvider>
      </InputProvider>
    </TotalProvider>
  );
}

function createStyles(theme) {
  return StyleSheet.create({
    container: {
      // width: "100dvw",
      // height: "100dvh",
      flex: 1,
      justifyContent: "center",
      alignItems: "center",
      backgroundColor: theme.background,
    },
  });
}
