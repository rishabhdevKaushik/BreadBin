import { StyleSheet } from "react-native";
import { GestureHandlerRootView } from "react-native-gesture-handler";
import { SafeAreaView } from "react-native-safe-area-context";
import Numpad from "../components/numpad";
import TopContainer from "../components/topContainer";
import {
  InputProvider,
  InputTypeProvider,
  TotalProvider,
  TransactionDateTimeProvider,
  TransactionTagsProvider,
} from "../utils/contexts";
import getTheme from "../utils/getTheme";

export default function home() {
  const theme = getTheme();

  const styles = createStyles(theme);
  return (
    <TotalProvider>
      <InputProvider>
        <InputTypeProvider>
          <TransactionTagsProvider>
            <TransactionDateTimeProvider>
              <SafeAreaView style={{ flex: 1 }}>
                <GestureHandlerRootView style={styles.container}>
                  <TopContainer theme={theme} />
                  <Numpad theme={theme} />
                </GestureHandlerRootView>
              </SafeAreaView>
            </TransactionDateTimeProvider>
          </TransactionTagsProvider>
        </InputTypeProvider>
      </InputProvider>
    </TotalProvider>
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
