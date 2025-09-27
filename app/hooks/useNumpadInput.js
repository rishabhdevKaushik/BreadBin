import inputTypes from "../constants/inputType";
import { useInput, useInputType, useTotal } from "../utils/contexts";
import { getValue, setValue } from "../utils/storage";

export function useNumpadInput() {
  let total = getValue("total") || "0";
  const { totalAmount, setTotalAmount } = useTotal();
  const { inputAmount, setInputAmount } = useInput();
  const { inputType, setInputType } = useInputType();

  function addNumberToInput(number) {
    if (number === ".") {
      if (inputAmount.includes(".")) {
        // console.log(". is already there");
        return;
      }
      setInputAmount(inputAmount + number);
      // console.log(input);
      return;
    } else if (isNaN(number)) {
      return;
    }
    const match = inputAmount.match(/\.(\d+)/);
    if (inputAmount.includes(".") && match && match[1].length === 2) {
      // console.log("two numbers are already there after '.'");
      return;
    }
    setInputAmount(inputAmount + number);
    // console.log(input);
  }

  function handleBackspace() {
    setInputAmount(inputAmount.slice(0, -1));
    // console.log(inputAmount);
  }

  async function handleCheckmark() {
    if (inputAmount === "") {
      return;
    }
    const newInput = Number(inputAmount) || 0;
    const currentTotal = Number(totalAmount) || 0;
    let newTotal;

    if (inputType.type === "Income") {
      newTotal = (currentTotal + newInput).toString();
      setInputType(inputTypes[0]);
    } else {
      newTotal = (currentTotal - newInput).toString();
    }

    setInputAmount("");
    setTotalAmount(newTotal);

    await setValue("total", newTotal);
  }

  function handleButtonPress(button) {
    // console.log(button);
    if (button === "checkmark") {
      // console.log("checkmark pressed");
      handleCheckmark();
    } else if (button === "backspace") {
      handleBackspace();
    } else {
      addNumberToInput(button);
    }
  }

  return { handleButtonPress };
}
