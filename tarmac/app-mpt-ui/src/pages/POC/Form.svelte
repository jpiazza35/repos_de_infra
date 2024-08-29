<script>
  import { createForm } from "svelte-forms-lib";
  import * as yup from "yup";

  import { flatten } from "utils/functions";
  import Input from "components/controls/input.svelte";

  const { form, errors, touched, isValid, handleChange, handleSubmit } =
    createForm({
      initialValues: {
        firstName: "",
        lastName: "",
        email: "",
        agingFactorOverride: "",
        overrideNote: "",
      },
      validationSchema: yup.object().shape({
        firstName: yup.string().required(),
        lastName: yup.string().required("Please enter your last name"),
        email: yup.string().email().required(),
        agingFactorOverride: yup.string(),
        overrideNote: yup.string().when("agingFactorOverride", {
          is: value => value !== "",
          then: yup
            .string()
            .required(
              "Override note is required if aging factor override is set",
            ),
          otherwise: yup.string(),
        }),
      }),
      onSubmit: values => {
        alert(JSON.stringify(values, null, 2));
      },
    });

  $: dirty = Object.values(flatten($touched)).some(val => val === true);
</script>

<div class="card">
  <div class="card-header">Static Input Examples</div>
  <div class="card-body">
    <form class="row g-3">
      <Input
        label="First Name"
        id="example1"
        error="Please enter your first name"
      />
      <Input label="Last Name" id="example2" />
      <Input
        label="Username"
        id="example3"
        error="Please choose an username"
        prepend="@"
      />
      <Input label="City" id="example4" colSize="6" />
      <Input label="Zip Code" id="example5" colSize="2" append="AR" />
    </form>
  </div>
</div>

<div class="card mt-3">
  <div class="card-header">Form with schema validation</div>
  <div class="card-body">
    <form class="row g-3" on:submit={handleSubmit}>
      <Input
        label="First Name"
        id="firstName"
        name="firstName"
        on:change={handleChange}
        on:blur={handleChange}
        value={$form.firstName}
        error={$errors.firstName}
        required
        showFeedback
      />
      <Input
        label="Last Name"
        id="lastName"
        name="lastName"
        on:change={handleChange}
        on:blur={handleChange}
        value={$form.lastName}
        error={$errors.lastName}
        required
        showFeedback
      />
      <Input
        label="Email"
        id="email"
        name="email"
        on:change={handleChange}
        on:blur={handleChange}
        value={$form.email}
        error={$errors.email}
        required
        showFeedback
      />
      <Input
        label="Aging Factor Override"
        id="agingFactorOverride"
        name="agingFactorOverride"
        type="number"
        max="1"
        min="0"
        step="0.1"
        on:change={handleChange}
        on:blur={handleChange}
        value={$form.agingFactorOverride}
        error={$errors.agingFactorOverride}
      />
      <Input
        label="Override Note"
        id="overrideNote"
        name="overrideNote"
        on:change={handleChange}
        on:blur={handleChange}
        value={$form.overrideNote}
        error={$errors.overrideNote}
      />
      <div class="col-12">
        <button
          class="btn btn-primary"
          type="submit"
          disabled={!($isValid && dirty)}>Submit form</button
        >
      </div>
    </form>
  </div>
</div>
