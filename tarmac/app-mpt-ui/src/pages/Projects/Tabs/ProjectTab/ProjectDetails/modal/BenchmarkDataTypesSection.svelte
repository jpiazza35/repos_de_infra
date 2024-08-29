<script>
  // @ts-nocheck
  import { createForm } from "svelte-forms-lib";
  import * as yup from "yup";
  import { BenchmarkDataTypeInfo } from "models/project/projectDetails";
  import Input from "components/controls/input.svelte";

  export let benchmarkDataTypes;
  export let benchmarkDataTypesStatus;
  export let selectedBenchmarkDataTypes = [];
  export let disabled;
  export let isFormModified;
  export let isUpdate;

  export const resetForm = () => handleReset();
  export const submitForm = e => handleSubmit(e);
  export const updateFormInitialValues = (types, isProjectUpdate) => updateInitialValues(getInitialValues(types, isProjectUpdate));

  let allBenchMarkDataTypes = benchmarkDataTypes;

  $: benchmarkDataTypes = $form.benchmarkDataTypes;
  $: isValid = !$errors.benchmarkDataTypes.some(error => Object.values(error).some(value => value !== ""));
  $: benchmarkDataTypesStatus = isValid;
  $: isFormModified = JSON.stringify(allBenchMarkDataTypes) !== JSON.stringify($form.benchmarkDataTypes);

  const { form, errors, handleChange, handleReset, handleSubmit, updateInitialValues } = createForm({
    initialValues: getInitialValues(selectedBenchmarkDataTypes, isUpdate),
    validationSchema: yup.object().shape({
      benchmarkDataTypes: yup.array().of(
        yup.object().shape({
          checked: yup.boolean(),
          overrideAgingFactor: yup.lazy(value => (value === "" ? yup.string() : yup.number().min(0).max(99.99))),
          overrideNote: yup.string().when(["checked", "overrideAgingFactor"], {
            is: (checked, overrideAgingFactor) => checked && overrideAgingFactor !== "",
            then: schema => schema.required("Override note is required if aging factor override is set"),
            otherwise: yup.string(),
          }),
        }),
      ),
    }),
    onSubmit: () => {},
  });

  function getInitialValues(selectedDataTypes, isProjectUpdate) {
    const benchmarkDataTypes = allBenchMarkDataTypes.map(element => {
      const { id } = element;
      const selectedDataType = selectedDataTypes.find(type => type.benchmarkDataTypeKey === id);
      const { overrideAgingFactor, overrideNote } = selectedDataType || {};
      const checked = isProjectUpdate ? !!selectedDataType : !!element.defaultDataType;

      return new BenchmarkDataTypeInfo({
        ...element,
        overrideAgingFactor: overrideAgingFactor || "",
        overrideNote: overrideNote || "",
        checked,
      });
    });

    allBenchMarkDataTypes = benchmarkDataTypes;
    return { benchmarkDataTypes };
  }

  const handleIncludeChange = (event, row) => {
    const value = event.target.checked;
    $form.benchmarkDataTypes[row].checked = value;
    if (!value) {
      $form.benchmarkDataTypes[row].overrideAgingFactor = "";
      $form.benchmarkDataTypes[row].overrideNote = "";
    }
  };

  // Sorting table by column
  let sortBy = { col: "Name", ascending: true };

  $: sort = column => {
    if (sortBy.col == column) {
      sortBy.ascending = !sortBy.ascending;
    } else {
      sortBy.col = column;
      sortBy.ascending = true;
    }

    // Modifier to sorting function for ascending or descending
    let sortModifier = sortBy.ascending ? 1 : -1;

    let sort = (a, b) => {
      a[column] = a[column] ?? "";
      b[column] = b[column] ?? "";

      return a[column] < b[column] ? -1 * sortModifier : a[column] > b[column] ? 1 * sortModifier : 0;
    };

    $form.benchmarkDataTypes = $form.benchmarkDataTypes?.sort(sort);
    // @ts-ignore
    $errors.benchmarkDataTypes = $errors.benchmarkDataTypes?.sort(sort);
  };
  const notAllowedChar = "-";
</script>

<div class="row">
  <div class="col-12">
    <div class="accordion accordion-flush" id="accBenchmarkData">
      <div class="accordion-item">
        <h4 class="accordion-header border" id="benchmarkHeader">
          <button
            data-cy="benchMarkDataTypeInfoTitle"
            class="accordion-button bg-white text-dark fw-600"
            type="button"
            data-bs-toggle="collapse"
            data-bs-target="#benchmarkData"
            aria-expanded="true"
            aria-controls="benchmarkData">Benchmark Data Type Info</button
          >
        </h4>
        <div
          id="benchmarkData"
          class="accordion-collapse collapse show p-4 border border-top-0"
          aria-labelledby="benchmarkHeader"
          data-bs-parent="accBenchmarkData"
        >
          <div class="d-flex justify-content-center">
            <div class="accordion-body col-lg-10 col-md-12 col-sm-12">
              <form>
                <table class="table table-bordered">
                  <thead>
                    <tr>
                      <th data-cy="include" on:click={() => sort("checked")}>Include</th>
                      <th data-cy="benchmarkDataType" on:click={() => sort("name")}>Benchmark Data Type</th>
                      <th data-cy="agingFactor" on:click={() => sort("agingFactor")}>Aging Factor</th>
                      <th data-cy="agingFactorOverride" on:click={() => sort("overrideAgingFactor")}>Aging Factor Override</th>
                      <th data-cy="overrideNote" on:click={() => sort("overrideNote")}>Override Note</th>
                    </tr>
                  </thead>
                  <tbody>
                    {#each $form.benchmarkDataTypes as item, i}
                      <tr>
                        <td
                          ><input
                            class="form-check-input"
                            type="checkbox"
                            data-cy={item.id}
                            on:change={e => handleIncludeChange(e, i)}
                            bind:checked={$form.benchmarkDataTypes[i].checked}
                            {disabled}
                          /></td
                        >
                        <td data-cy={item.name}>{item.longAlias}</td>

                        <td data-cy="{item.id}{item.agingFactor}">{item.agingFactor?.toFixed(2)}</td>

                        <td>
                          <Input
                            colSize="12"
                            id="overrideAgingFactor"
                            name={`benchmarkDataTypes[${i}].overrideAgingFactor`}
                            type="number"
                            max="99.99"
                            min="0"
                            step="0.1"
                            on:blur={handleChange}
                            on:keypress={event => {
                              if (event.key === notAllowedChar) {
                                event.preventDefault();
                              }
                            }}
                            on:change={event => {
                              if (event.key === notAllowedChar) {
                                event.preventDefault();
                              }
                            }}
                            disabled={disabled || $form.benchmarkDataTypes[i].checked === false}
                            value={$form.benchmarkDataTypes[i].overrideAgingFactor}
                            error={$errors.benchmarkDataTypes[i]["overrideAgingFactor"]}
                          />
                        </td>
                        <td>
                          <Input
                            colSize="12"
                            id="overrideNote"
                            name={`benchmarkDataTypes[${i}].overrideNote`}
                            maxlength="1000"
                            on:change={handleChange}
                            on:blur={handleChange}
                            disabled={disabled || $form.benchmarkDataTypes[i].checked === false}
                            value={$form.benchmarkDataTypes[i].overrideNote}
                            error={$errors.benchmarkDataTypes[i]["overrideNote"]}
                          />
                        </td>
                      </tr>
                    {/each}
                  </tbody>
                </table>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<style>
  #benchmarkData {
    text-align: -webkit-center;
  }

  .fw-600 {
    font-weight: 600;
  }
</style>
