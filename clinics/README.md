# Clinic Presets

歯科医院別のCADプリセット値を保持するJSONファイル群。

## URL形式

```
https://ceramicadentallaboratory.github.io/ceramica-cad-sim/?clinic=<slug>
```

例：`?clinic=sample-dental` → `clinics/sample-dental.json` を読み込んでシミュレーターを起動。

## JSONスキーマ

```json
{
  "clinicName": "歯科医院名（表示用）",
  "mode": "hoken | zirconia | implant",
  "values": {
    "cementGap": 0.040,
    "extraCementGap": 0.050,
    "marginDistance": 1.00,
    "antagonistDistance": -0.05,
    "adjacentDistance": -0.05,
    "emergenceAngle": 35
  },
  "lastUpdated": "YYYY-MM-DD",
  "updatedBy": "Ceramica Lab",
  "notes": "自由記述"
}
```

## 運用

1. 新規医院：`<slug>.json` を追加
2. 値変更：該当ファイル編集 → コミット → push
3. 1-2分でGitHub Pages再デプロイ
4. 先生がURLを再読込すれば最新値

## slug規則

- 英小文字＋数字＋ハイフンのみ（`plus-dental`, `yonezawa-dental`）
- スペース・日本語・特殊文字NG（URL埋込＆パストラバーサル防止のため）
