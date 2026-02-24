import {
  ActionPanel,
  Action,
  Form,
  showToast,
  Toast,
} from "@raycast/api";
import { useState } from "react";
import { exec } from "child_process";
import presetPasswords from "./data/passwords.json";

type PasswordEntry = {
  label: string;
  value: string;
};

const PASSWORDS: PasswordEntry[] = [
  ...presetPasswords,
  { label: "그 외", value: "custom" },
];

export default function Command() {
  const [isLoading, setIsLoading] = useState(false);
  const [selectedFiles, setSelectedFiles] = useState<string[]>([]);
  const [selectedPassword, setSelectedPassword] = useState<string>(
    PASSWORDS[0].value
  );
  const [customPassword, setCustomPassword] = useState<string>("");

  async function handleSubmit() {
    const inputPath = selectedFiles[0];

    if (!inputPath) {
      await showToast({
        style: Toast.Style.Failure,
        title: "PDF 파일 선택",
      });
      return;
    }

    const password =
      selectedPassword === "custom" ? customPassword : selectedPassword;

    if (!password) {
      await showToast({
        style: Toast.Style.Failure,
        title: "비밀번호 입력",
      });
      return;
    }

    setIsLoading(true);

    const outputPath = inputPath.replace(/\.pdf$/i, "_unlocked.pdf");
    const command = `qpdf --password="${password}" --decrypt "${inputPath}" "${outputPath}"`;

    exec(command, async (error, stdout, stderr) => {
      setIsLoading(false);

      if (error) {
        await showToast({
          style: Toast.Style.Failure,
          title: "잠금 해제 실패",
          message: stderr || error.message,
        });
        return;
      }

      await showToast({
        style: Toast.Style.Success,
        title: "PDF 잠금 해제 완료 ✅",
        message: outputPath,
      });
    });
  }

  return (
    <Form
      isLoading={isLoading}
      actions={
        <ActionPanel>
          <Action.SubmitForm title="잠금 해제 실행하기" onSubmit={handleSubmit} />
        </ActionPanel>
      }
    >
      <Form.FilePicker
        id="file"
        title="PDF 파일 선택"
        allowMultipleSelection={false}
        value={selectedFiles}
        onChange={setSelectedFiles}
      />

      <Form.Dropdown
        id="passwordChoice"
        title="비밀번호 선택"
        value={selectedPassword}
        onChange={setSelectedPassword}
      >
        {PASSWORDS.map((pw) => (
          <Form.Dropdown.Item
            key={pw.value}
            value={pw.value}
            title={pw.label}
          />
        ))}
      </Form.Dropdown>

      {selectedPassword === "custom" && (
        <Form.PasswordField
          id="customPassword"
          title="비밀번호 직접 입력"
          placeholder="비밀번호를 입력하세요"
          value={customPassword}
          onChange={setCustomPassword}
        />
      )}
    </Form>
  );
}
