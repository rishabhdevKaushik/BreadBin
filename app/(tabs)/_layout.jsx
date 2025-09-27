import { Stack } from "expo-router";
import { StatusBar } from "expo-status-bar";
import getTheme from "../utils/getTheme";

{
  /* <Stack.Screen name="(tabs)" options={{ headerShown: false }} /> */
}
export default function RootLayout() {
  const theme = getTheme();
  return (
    <>
      <StatusBar style="auto" backgroundColor={theme.backgroundLight} />
      <Stack>
        <Stack.Screen name="index" options={{ headerShown: false }} />
      </Stack>
    </>
  );
}
