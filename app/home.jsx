import { StyleSheet, View } from "react-native";
import Input from "./components/input";
import Numpad from "./components/numpad";
import Colors from "./constants/theme";

export default function home() {
  const theme = Colors.dark;
  const styles = createStyles(theme);
  return (
    <View style={styles.container}>
      <Input theme={theme} />
      <Numpad theme={theme} />
    </View>
  );
}

function createStyles(theme) {
  return StyleSheet.create({
    container: {
      flex: 1,
      justifyContent: "center",
      alignItems: "center",
      backgroundColor: theme.background,
    },
  });
}
