<script>
  export let auditValues = {};
  export let selectedStandards = [];

  const formatNumber = number => {
    if (number) {
      number = number.toFixed(2);
      return new Intl.NumberFormat("en-US", {
        style: "currency",
        currency: "USD",
      }).format(number);
    }

    return number;
  };
</script>

<div class="row my-4">
  {#if !auditValues.annual && !auditValues.hourly && selectedStandards.length > 0}
    <div style="font-size: 12px; margin-left: 10px">
      <i class="fa fa-exclamation-triangle text-danger" />
      <span class="text-danger">There is no data for the selected standard job</span>
    </div>
  {/if}
  <div class="col-12">
    <div class="card border">
      <div class="card-header">
        <h6 class="my-1" data-cy="audit">Audit</h6>
      </div>
      <div class="card-body">
        <div class="row">
          <div class="col-12 d-flex justify-content-around">
            <div class="d-flex flex-nowrap justify-content-end col-10">
              <table class=" m-2 col-2" style="text-align: right;">
                <thead style="height: 70px" />
                <tbody>
                  <tr>
                    <td>Annual Base Salary</td>
                  </tr>
                  <tr>
                    <td>Hourly Base Salary</td>
                  </tr>
                </tbody>
              </table>
              <table class="audit-table m-2 col-5">
                <thead>
                  <tr>
                    <th colspan="3">National Base Pay - Survey Values</th>
                  </tr>
                  <tr style="background: #D6D6D7">
                    <th>10th %ile</th>
                    <th>50th %ile</th>
                    <th>90th %ile</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>{auditValues.annual ? formatNumber(auditValues.annual.tenthPercentile) : "---"}</td>
                    <td>{auditValues.annual ? formatNumber(auditValues.annual.fiftiethPercentile) : "---"}</td>
                    <td>{auditValues.annual ? formatNumber(auditValues.annual.ninetiethPercentile) : "---"}</td>
                  </tr>
                  <tr>
                    <td>{auditValues.hourly ? formatNumber(auditValues.hourly.tenthPercentile) : "---"}</td>
                    <td>{auditValues.hourly ? formatNumber(auditValues.hourly.fiftiethPercentile) : "---"}</td>
                    <td>{auditValues.hourly ? formatNumber(auditValues.hourly.ninetiethPercentile) : "---"}</td>
                  </tr>
                </tbody>
              </table>
              <table class="audit-table m-2 col-3">
                <thead>
                  <tr>
                    <th>Client Base Pay</th>
                  </tr>
                  <tr>
                    <th>Average</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>{auditValues.annual ? formatNumber(auditValues.annual.average) : "---"}</td>
                  </tr>
                  <tr>
                    <td>{auditValues.hourly ? formatNumber(auditValues.hourly.average) : "---"}</td>
                  </tr>
                </tbody>
              </table>
              <table class="audit-table m-2 col-2">
                <thead>
                  <tr>
                    <th style="padding: 10px 5px;">Compa-Ratio to <br /> 50th %ile</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>{auditValues.annual ? auditValues.annual.compaRatio : "---"}</td>
                  </tr>
                  <tr>
                    <td>{auditValues.hourly ? auditValues.hourly.compaRatio : "---"}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<style>
  .audit-table thead tr th {
    border: 1px solid #d6d6d7;
    background: #747477;
    padding: 5px;
    text-align: center;
    color: #ffffff !important;
    font-weight: 500;
  }

  .audit-table tbody tr td {
    border: 1px solid #d6d6d7;
    padding: 5px;
    text-align: center;
  }

  .card-header {
    background-color: #d6d6d7 !important;
  }
</style>
