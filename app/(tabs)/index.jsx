import { StyleSheet } from "react-native";
import { GestureHandlerRootView } from "react-native-gesture-handler";
import { SafeAreaView } from "react-native-safe-area-context";
import { TransactionProvider } from "../../src/utils/contexts";
import getTheme from "../../src/utils/getTheme";
import Numpad from "../components/numpad";
import TopContainer from "../components/topContainer";

export default function home() {
  const theme = getTheme();

  const styles = createStyles(theme);
  return (
    <TransactionProvider>
      <SafeAreaView style={{ flex: 1 }}>
        <GestureHandlerRootView style={styles.container}>
          <TopContainer theme={theme} />
          <Numpad theme={theme} />
        </GestureHandlerRootView>
      </SafeAreaView>
    </TransactionProvider>
  );
}

function createStyles(theme) {
  return StyleSheet.create({
    container: {
      width: "100%",
      height: "100%",
      flex: 1,
      justifyContent: "center",
      alignItems: "center",
      backgroundColor: theme.background,
      position: "relative",
    },
  });
}
