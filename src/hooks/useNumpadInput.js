import inputTypes from "../constants/inputType";
import {
  useTransaction,
} from "../utils/contexts";
import { setValue } from "../utils/storage";
import { addTransaction } from "../utils/transactions";

export function useNumpadInput() {
    const {
    totalAmount,
    setTotalAmount,
    inputAmount,
    setInputAmount,
    inputType,
    setInputType,
    transactionTags,
    setTransactionTags,
    transactionDateTime,
    setTransactionDateTime,
  } = useTransaction();

  function addNumberToInput(number) {
    if (number === ".") {
      if (inputAmount.includes(".")) {
        return;
      }
      setInputAmount(inputAmount + number);
      return;
    } else if (isNaN(number)) {
      return;
    }
    const match = inputAmount.match(/\.(\d+)/);
    if (inputAmount.includes(".") && match && match[1].length === 2) {
      // Two numbers are already there after '.'
      return;
    }
    setInputAmount(inputAmount + number);
  }

  function handleBackspace() {
    setInputAmount(inputAmount.slice(0, -1));
  }

  async function handleCheckmark() {
    if (inputAmount === "") {
      return;
    }
    const newInput = Number(inputAmount) || 0;
    const currentTotal = Number(totalAmount) || 0;
    let newTotal;

    if (inputType.type === "earning") {
      newTotal = (currentTotal + newInput).toString();
      setInputType(inputTypes[1]);
    } else {
      newTotal = (currentTotal - newInput).toString();
    }

    // Add transaction to log
    const transaction = {
      amount: inputAmount,
      type: inputType.type,
      datetime: transactionDateTime,
      tags: transactionTags,
    };
    await addTransaction(transaction);

    // Reset values
    setInputAmount("");
    setTotalAmount(newTotal);
    setTransactionTags([]);
    setTransactionDateTime(null);

    await setValue("total", newTotal);
  }

  function handleButtonPress(button) {
    if (button === "checkmark") {
      handleCheckmark();
    } else if (button === "backspace") {
      handleBackspace();
    } else {
      addNumberToInput(button);
    }
  }

  return { handleButtonPress };
}
